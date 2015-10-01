Redis Parcel and CSD for Cloudera's CDH 5
=============
This parcel and CSD greatly simplifies deploying and managing Redis on your Cloudera cluster. 
The CSD will setup Redis sentinel as well when you deploy the service to multiple instances.

## Table of Contents
<!-- START doctoc generated TOC please keep comment here to allow auto update -->
<!-- DON'T EDIT THIS SECTION, INSTEAD RE-RUN doctoc TO UPDATE -->
**Table of Contents**  *generated with [DocToc](http://doctoc.herokuapp.com/)*

- [Installation](#installation)
  - [1. Install the CSD](#1-install-the-csd)
  - [2. Downloading and Distributing Redis Parcel](#2-downloading-and-distributing-redis-parcel)
- [Known Limitations](#known-limitations)
    - [Adding/Removing slaves to existing Redis cluster](#addingremoving-slaves-to-existing-redis-cluster)
      - [Workaround](#workaround)
    - [Changing Redis Sentinel port on existing Cluster](#changing-redis-sentinel-port-on-existing-cluster)
  - [Configuring Redis Sentinel Parameters](#configuring-redis-sentinel-parameters)
- [Q&A](#q&a)
    - [Service fails to start with this error reported: start_processes.sh: line 3: /var/lib/redis/src/redis-sentinel: No such file or directory](#service-fails-to-start-with-this-error-reported-start_processessh-line-3-varlibredissrcredis-sentinel-no-such-file-or-directory)

<!-- END doctoc generated TOC please keep comment here to allow auto update -->

### Installation

#### 1. Install the CSD

1. **IMPORTANT:** The CSD will build Redis the first time it runs, please make sure both gcc/cc and make are installed on **all** nodes.
2. Download the latest CSD release from this repository (alternatively, you can build it using the maven command "mvn assembly:assembly" and use the jar compiled in target folder)
3. Upload the CSD jar to your Cloudera Manager node, place it in /opt/cloudera/csd/
4. Restart cloudera-scm-manager on Clouder Manager node:

```bash
service cloudera-scm-server restart
```



#### 2. Downloading and Distributing Redis Parcel

1. Clone this git repository (you do not need to clone it inside your Cloudera cluster)
2. Setup a quick HTTP server to serve as cloudera repository, the HTTP server will need to serve the "parcel" directory:

 ```bash
 cd parcel
 python -m SimpleHTTPServer
 ```

3. Go to your Cloudera Manager: http://x.x.x.x:7180 and login with your admin credentials
4. Click on the parcels icon on the top right corner (next to the search bar)
5. Click on "Edit Settings"
6. Add a new value in "Remote Parcel Repository URLs", enter the IP address for the machine on which you just setup your HTTP server, for example: http://x.x.x.x:8000 
7. Save your changes and go back to Parcels page by clicking on the Parcels icon on the top right corner (next to the search bar)
8. Click on "Check for New Parcels"
9. You should see "REDIS" parcel in the list. Download it, then distribute it and activate it
10. You will be prompted to restart your cluster, click "Restart". Once that's done, you will need to restart "Cloudera Management Service" manually as well
11. Now you should be able to simply add your new Redis service through CM. (click on the little arrow next your cluster name and click "Add Service", follow the wizard instructions)

### Known Limitations

##### Adding/Removing slaves to existing Redis cluster
When you add a new instance to your Redis service in Cloudera, 
there is a chance that this new node will become a master. This happens because whenever the Redis service is restarted,
it rewrite the redis.conf file and it uses the first instance as the master. For example, if you have a cluster with the following nodes hostnames: node2, node3 and node4. And then you add "node1", node1 might become the new master and might causes to wipe out existing data.
 
###### Workaround
If you really want to add a new node, you can do the following:

1. Login onto redis-cli shell
2. Issue save command
3. Stop the Redis service (In CM)
4. Backup the data dump file to a safe location
5. In CM, navigate to "Redis" service page, expand "Actions" drop-down menu and click on "Reset Topology"
6. Add/Remove Redis nodes
7. Start up the service, find what the new Redis master node is. 
8. Stop the service, restore the backup from the dump file
9. Start up Redis service again

##### Changing Redis Sentinel port on existing Cluster
The CSD will avoid re-writing redis-sentinel.conf every time you deploy new configuraiton, that's because Redis sentinel rewrites this file every time a fail-over occurs, the only way to deploy new Redis sentinel port is by using "Reset Topolgy" action (accessible through CM's UI). However, that might causes another node to become a master and cause some data discrapencies (i.e. if that's node was not fully-sync). If you really want to change sentinel port, consider the performing steps in the section above.

#### Configuring Redis Sentinel Parameters
Currently Redis sentinel will always be configured with the default settings, the only configurable setting is the port number (but please refer to the section above before changing the port number). 

### Q&A

##### Service fails to start with this error reported: start_processes.sh: line 3: /var/lib/redis/src/redis-sentinel: No such file or directory

This means the CSD failed to build Redis. To troubleshoot this error, login manually to the node Redis is being installed on, and run the following

```bash
sudo su redis
cd /var/lib/redis/deps
make hiredis jemalloc linenoise lua
cd /var/lib/redis
make
```

You should resolve any errors until you are able to completely build Redis. Once done, please run 'make clean' and perform the same steps needed to resolve the build errors on all other CDH nodes. Then retry installing the service on Cloudera Manager.

*Note:* Please feel free to submit pull requests that you think might be useful to others so they don't run into the same errors you encountered.  

 


