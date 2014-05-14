#!/bin/bash

# Docker interface ip
DOCKERIP="10.1.42.1"

# Clean up
containers=( skydns skydock mongos1r1 mongos1r2 mongos2r1 mongos2r2 mongos3r1 mongos3r2 configservers1 configservers2 configservers3 mongos1 )
for c in ${containers[@]}; do
	docker kill ${c} 	> /dev/null 2>&1
	docker rm ${c} 		> /dev/null 2>&1
done

# Uncomment to build mongo image yourself otherwise it will download from docker index.
#docker build -t jacksoncage/mongo /home/vagrant/docker/mongo > /dev/null 2>&1

# Setup skydns/skydock
docker run -d -p ${DOCKERIP}:53:53/udp --name skydns crosbymichael/skydns -nameserver 8.8.8.8:53 -domain docker
docker run -d -v /var/run/docker.sock:/docker.sock --name skydock crosbymichael/skydock -ttl 30 -environment dev -s /docker.sock -domain docker -name skydns

for (( i = 1; i < 4; i++ )); do
	# Create mongd servers
	docker run --dns ${DOCKERIP} --name mongos${i}r1 -P -i -d -e OPTIONS="d --replSet set${i} --dbpath /data/db" jacksoncage/mongo
	docker run --dns ${DOCKERIP} --name mongos${i}r2 -P -i -d -e OPTIONS="d --replSet set${i} --dbpath /data/db" jacksoncage/mongo
	sleep 15 # Wait for mongo to start
	# Setup replica set
	docker run --dns ${DOCKERIP} -P -i -t -e OPTIONS=" ${DOCKERIP}:$(docker port mongos${i}r1 27017|cut -d ":" -f2) /initiate.js" jacksoncage/mongo
	sleep 30 # Waiting for set to be initiated
	docker run --dns ${DOCKERIP} -P -i -t -e OPTIONS=" ${DOCKERIP}:$(docker port mongos${i}r1 27017|cut -d ":" -f2) /setupReplicaSet${i}.js" jacksoncage/mongo
	# Create configserver
	docker run --dns ${DOCKERIP} --name configservers${i} -P -i -d -e OPTIONS="d --configsvr --dbpath /data/db --port 27017" jacksoncage/mongo
done

# Setup and configure mongo router
docker run --dns ${DOCKERIP} --name mongos1 -P -i -d -e OPTIONS="s --configdb configservers1.mongo.dev.docker:27017,configservers2.mongo.dev.docker:27017,configservers3.mongo.dev.docker:27017 --port 27017" jacksoncage/mongo
sleep 10 # Wait for mongo to start
docker run --dns ${DOCKERIP} -P -i -t -e OPTIONS=" ${DOCKERIP}:$(docker port mongos1 27017|cut -d ":" -f2) /addShard.js" jacksoncage/mongo
sleep 10 # Wait for sharding to be enabeld
docker run --dns ${DOCKERIP} -P -i -t -e OPTIONS=" ${DOCKERIP}:$(docker port mongos1 27017|cut -d ":" -f2) /addDB.js" jacksoncage/mongo
docker run --dns ${DOCKERIP} -P -i -t -e OPTIONS=" ${DOCKERIP}:$(docker port mongos1 27017|cut -d ":" -f2)/admin /enabelSharding.js" jacksoncage/mongo

echo "#####################################"
echo "MongoDB Cluster is now ready to use"
echo "Connect to cluster by:"
echo "$ mongo --port $(docker port mongos1 27017|cut -d ":" -f2)"