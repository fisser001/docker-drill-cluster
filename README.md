# Drill benchmarking cluster with Hive and HDFS based on Docker-compose
This repository contains all the container related code for creating the container images and starting the benchmarking cluster.  

All container have been build by Docker and executed by Docker-compose.

All given information/code belong only to Apache Drill which was one tool of the benchmark. Each component of Drill has its own Docker image.

## Versions
- Hadoop: 2.7.6
- Hive: 2.3.0
- Drill: 1.15.0
- Zookeeper: 3.3
- Postgres: 9.5.3

## Subfolder and relevant files

The repository is divided into the following subfolder:

### Drillbit
Contains the definition for the creation of an Apache Drill Docker image. Drill does not need any base image because the cluster only consists of Drillbits which are the lowest level.

### Docker-compose
This file contains the main definiton of the Apache Drill cluster with additional components like HDFS, Hive, Zookeeper, etc. which have been used by the benchmark. The file contains all components that are relevant for starting the benchmark environment.

The Hadoop components which are used within in the Docker-compose file are described in the following repository: https://github.com/fisser001/docker-hadoop

The Hive components which are used within in the Docker-compose file are described in the following repository: https://github.com/fisser001/docker-hive

The Hive Metastore component which is used within in the Docker-compose file is described in the following repository: https://github.com/fisser001/docker-hive-metastore-postgresql

In order to start the cluster, Docker and Docker-compose have to be installed on the machine where the cluster should be started. If that is fullfilled navigate to the folder where the Docker-compose file is located. The following command has to be executed for starting all relevant components:

```console
docker-compose up
```

After execution of the Docker-compose file the following components will start:

1.  Hadoop Namenode (1x)
2.  Hadoop Datanode (3x)
3.  Hadoop Resourcemanager (1x)
4.  Historyserver (1x)
5.  Nodemanager (2x)
6.  Hive-Server (1x)
7.  Hive-Metastore (1x)
8.  Postgres DB for Hive-Metastore (1x)
9.  Drillbit (5x)
10. Zookepper (1x)

In order to shut down all components of the environment the following command needs to be executed:
```console
docker-compose stop
```

## Access to GUIs
Once all containers have been started the GUIs of the components can be accessed by the following URLs within a browser:

- Namenode: http://<docker_IP_address>:50070/dfshealth.html#tab-overview
- History server: http://<docker_IP_address>:8188/applicationhistory
- Datanode: http://<docker_IP_address>:50075/
- Nodemanager: http://<docker_IP_address>:8042/node
- Resource manager: http://<docker_IP_address>:8088/
- Drillbit1: http://<docker_IP_address>:8047/
- Drillbit2: http://<docker_IP_address>:8048/
- Drillbit3: http://<docker_IP_address>:8049/
- Drillbit4: http://<docker_IP_address>:8050/
- Drillbit5: http://<docker_IP_address>:8051/

In order to find the IP address that has been given to the component one can execute the following commands:
```console
docker network ls #In order to get the network name
docker network inspect <NETWORK NAME> #Exchange the network name with the identified name with the previous command.
```

## Access the container

### Hive
Navigate into the Docker-compose directory and execute the following command:
```console
docker-compose -p benchmark exec hive-server bash
```
Within in this container one can access the hive-server with the following command in order to execute hive queries:
```console
/opt/hive/bin/beeline -u jdbc:hive2://localhost:10000
```

### Drillbit 
Navigate into the Docker-compose directory and execute the following command. Here the Drillbit number 1 is entered:
```console
docker-compose -p benchmark exec drillbit1 bash
```
In order to use the Hive schema Apache Drill needs to be configured. To configure Drill the following curl commands has to be executed from the shell within the Docker container.
```console
curl -X POST -H "Content-Type: application/json" -d '{"name":"hive", "config": {"type": "hive","enabled": true,"configProps": {"hive.metastore.uris": "thrift://hive-metastore:9083","hive.metastore.sasl.enabled": "false","fs.default.name": "hdfs://namenode"}}}' http://drillbit1:8047/storage/hive.json
```
In order to have a better query performance for parquet file set the following parameter within in the gui of one Drillbit.
```console
set store.hive.parquet.optimize_scan_with_native_reader=true;
```

Within this container one can access the impala shell with the following command in order to execute queries:
```console
/opt/drill/apache-drill-1.15.0/bin/sqlline -u jdbc:drill:zk=zookeeper:2181
```