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

echo "port $PORT" >> /var/lib/redis/redis.conf
echo "tcp-backlog $TCP_BACKLOG" >> /var/lib/redis/redis.conf
echo "timeout $TIMEOUT" >> /var/lib/redis/redis.conf
echo "tcp-keepalive $TCP_KEEPALIVE" >> /var/lib/redis/redis.conf
echo "loglevel $LOGLEVEL" >> /var/lib/redis/redis.conf
echo "logfile $LOGFILE" >> /var/lib/redis/redis.conf
echo "databases $DATABASES" >> /var/lib/redis/redis.conf
echo "save $SAVE" >> /var/lib/redis/redis.conf
echo "stop-writes-on-bgsave-error $STOP_WRITES_ON_BGSAVE_ERROR" >> /var/lib/redis/redis.conf
echo "rdbcompression $RDBCOMPRESSION" >> /var/lib/redis/redis.conf
echo "rdbchecksum $RDBCHECKSUM" >> /var/lib/redis/redis.conf
echo "dbfilename $DBFILENAME" >> /var/lib/redis/redis.conf
echo "dir $DATA_DIR" >> /var/lib/redis/redis.conf
echo "slave-serve-stale-data $SLAVE_SERVE_STALE_DATA" >> /var/lib/redis/redis.conf
echo "slave-read-only $SLAVE_READ_ONLY" >> /var/lib/redis/redis.conf
echo "repl-disable-tcp-nodelay $REPL_DISABLE_TCP_NODELAY" >> /var/lib/redis/redis.conf
echo "slave-priority $SLAVE_PRIORITY" >> /var/lib/redis/redis.conf
echo "appendonly $APPENDONLY" >> /var/lib/redis/redis.conf
echo "appendfilename \"$APPENDFILENAME\"" >> /var/lib/redis/redis.conf
echo "appendfsync $APPENDFSYNC" >> /var/lib/redis/redis.conf
echo "no-appendfsync-on-rewrite $NO_APPENDFSYNC_ON_REWRITE" >> /var/lib/redis/redis.conf
echo "auto-aof-rewrite-percentage $AUTO_AOF_REWRITE_PERCENTAGE" >> /var/lib/redis/redis.conf
echo "auto-aof-rewrite-min-size ${AUTO_AOF_REWRITE_MIN_SIZE}mb" >> /var/lib/redis/redis.conf
echo "aof-load-truncated $AOF_LOAD_TRUNCATED" >> /var/lib/redis/redis.conf
echo "lua-time-limit $LUA_TIME_LIMIT" >> /var/lib/redis/redis.conf
echo "slowlog-log-slower-than $SLOWLOG_LOG_SLOWER_THAN" >> /var/lib/redis/redis.conf
echo "slowlog-max-len $SLOWLOG_MAX_LEN" >> /var/lib/redis/redis.conf
echo "latency-monitor-threshold $LATENCY_MONITOR_THRESHOLD" >> /var/lib/redis/redis.conf
echo "notify-keyspace-events \"$NOTIFY_KEYSPACE_EVENTS\"" >> /var/lib/redis/redis.conf
echo "hash-max-ziplist-entries $HASH_MAX_ZIPLIST_ENTRIES" >> /var/lib/redis/redis.conf
echo "hash-max-ziplist-value $HASH_MAX_ZIPLIST_VALUE" >> /var/lib/redis/redis.conf
echo "list-max-ziplist-entries $LIST_MAX_ZIPLIST_ENTRIES" >> /var/lib/redis/redis.conf
echo "list-max-ziplist-value $LIST_MAX_ZIPLIST_VALUE" >> /var/lib/redis/redis.conf
echo "set-max-intset-entries $SET_MAX_INTSET_ENTRIES" >> /var/lib/redis/redis.conf
echo "zset-max-ziplist-entries $ZSET_MAX_ZIPLIST_ENTRIES" >> /var/lib/redis/redis.conf
echo "zset-max-ziplist-value $ZSET_MAX_ZIPLIST_VALUE" >> /var/lib/redis/redis.conf
echo "hll-sparse-max-bytes $HLL_SPARSE_MAX_BYTES" >> /var/lib/redis/redis.conf
echo "activerehashing $ACTIVEREHASHING" >> /var/lib/redis/redis.conf
echo "client-output-buffer-limit $CLIENT_OUTPUT_BUFFER_LIMIT" >> /var/lib/redis/redis.conf
echo "hz $HZ" >> /var/lib/redis/redis.conf
echo "aof-rewrite-incremental-fsync $AOF_REWRITE_INCREMENTAL_FSYNC" >> /var/lib/redis/redis.conf
echo "daemonize no" >> /var/lib/redis/redis.conf