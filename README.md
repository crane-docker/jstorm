## JStorm
version 2.2.1

## Setting up a minimal JStorm cluster
# 1. Apache Zookeeper is a must for running a JStorm cluster. Start it first. Since the Zookeeper "fails fast" it's better to always restart it.
```shell
$ docker pull zookeeper
```
```shell
$ docker run -d -p 2181:2181 --restart always --name storm-zk zookeeper
```
# 2. The Nimbus daemon has to be connected with the Zookeeper. It's also a "fail fast" system.
```shell
docker pull cranelana/jstorm:v2.2.1
```
```shell
$ docker run -d --restart always --name jstorm-nimbus --link storm-zk:zookeeper cranelana/jstorm:v2.2.1 jstorm nimbus
```

# 3. Finally start a single Supervisor node. It will talk to the Nimbus and Zookeeper.
```shell
$ docker run -d --restart always --name jstorm-supervisor --link storm-zk:zookeeper --link jstorm-nimbus:nimbus cranelana/jstorm:v2.2.1 jstorm supervisor
```

# 4. Now you can submit a topology to our cluster.
Assuming you have topology.jar in the current directory.
```shell
$ docker run --link jstorm-nimbus:nimbus -it --rm -v $(pwd)/topology.jar:/topology.jar cranelana/jstorm:v2.2.1 jstorm jar /topology.jar com.xxx.jstorm.starter.WordCountTopology topology
```
# 5. Optionally, you can start the JStorm UI.
```shell
$ docker pull cranelana/jstorm-ui:v2.2.1
```
```shell
$ docker run -d -p 28080:8080 --restart always --name jstorm-ui --link jstorm-nimbus:nimbus --link storm-zk:zookeeper cranelana/jstorm-ui:v2.2.1
```
