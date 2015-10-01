# Copyright (c) 2015 Rakuten Marketing, LLC
# Licensed to Rakuten Marketing, LLC under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  Rakuten Marketing licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# Author: Aiman Najjar <aiman.najjar@rakuten.com>

# Time marker for both stderr and stdout
# date 1>&2

function log {
  timestamp=$(date)
  echo "$timestamp: $1"       #stdout
  echo "$timestamp: $1" 1>&2; #stderr
}

chmod +x $CONF_DIR/scripts/start_processes.sh
chmod +x $CONF_DIR/scripts/build_redis.sh
chmod +x $CONF_DIR/scripts/start_processes.sh
chmod +x $CONF_DIR/scripts/generate_conf_file.sh
mkdir -p /var/lib/redis

ROLE=$1
CMD=$2

# Need to create a copy of Redis directory in the process work directory
if [ ! -f /var/lib/redis/src/redis-server ]; then
		log "First run of this service, building Redis"
		log "Copying redis source to /var/lib/redis"
		cp -R $REDIS_SRC_HOME/* /var/lib/redis
		log "Building Redis on ${MY_HOST}"
		bash $CONF_DIR/scripts/build_redis.sh		
		
fi

# we rewrite Configuration file every time we restart the service
rm /var/lib/redis/redis.conf 
touch /var/lib/redis/redis.conf

# ------- 
# Determine Masters and Slaves
# -------
# Extract available Redis hosts
i=0    
while read line; do		
	redisHost=(${line//:/ })
	log "Detected redis host: ${redisHost[0]}"
	if [ $i -eq 0 ]; then
		master=${redisHost[0]}
	else
		slave[$i-1]=${redisHost[0]}
	fi
	i=$[i+1]		
done <$CONF_DIR/redis_hosts.properties

# If number of nodes is greater than 1, configure replication and fail-over (redis-sentinel.conf)
if [ $i -gt 1 ]; then
	
	# First node will be used as master, remaining ones as slaves
	log "${master} will be Redis master"
	for rhost in "${slave[@]}"
	do
		log "${rhost} will be a Redis slave"
	done
	
	if [ "$master" != "$MY_HOST" ]; then
		echo "slaveof ${master} $PORT" >> /var/lib/redis/redis.conf
	else
		echo "#original_master_node" >> /var/lib/redis/redis.conf		
	fi
	
	# Configuring Sentinel	
	if [ ! -f /var/lib/redis/redis-sentinel.conf ]; then
		log "Configuring redis-sentinel"
		echo "port $SENTINEL_PORT" >> /var/lib/redis/redis-sentinel.conf
		echo "sentinel monitor mymaster ${master} $PORT 2" >> /var/lib/redis/redis-sentinel.conf
		echo "sentinel down-after-milliseconds mymaster 60000" >> /var/lib/redis/redis-sentinel.conf
		echo "sentinel failover-timeout mymaster 180000" >> /var/lib/redis/redis-sentinel.conf
		echo "sentinel parallel-syncs mymaster 1" >> /var/lib/redis/redis-sentinel.conf
		echo "dir $DATA_DIR" >> /var/lib/redis/redis.conf			
		echo "dir $DATA_DIR" >> /var/lib/redis/redis-sentinel.conf
	fi
	
	# Add remaining configuration settings to redis.conf
	bash $CONF_DIR/scripts/generate_conf_file.sh
	
	# Start Redis Sentinel & Server
	exec $CONF_DIR/scripts/start_processes.sh
	
else
	# It's only a single node, configure without Replication/Failover
	log "There is only one instance installed. Will not configure replication and fail-over"
	# Generate configuration file
	bash $CONF_DIR/scripts/generate_conf_file.sh
	exec /var/lib/redis/src/redis-server /var/lib/redis/redis.conf
fi

