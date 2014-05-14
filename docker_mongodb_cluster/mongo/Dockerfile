FROM ubuntu:latest
MAINTAINER  Love Nyberg "love@bloglovin.com"

# Add 10gen official apt source to the sources list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list

# Install MongoDB
RUN apt-get update && apt-get install -y mongodb-org

# Create the MongoDB data directory
RUN mkdir -p /data/db

EXPOSE 27017

ADD initiate.js /initiate.js
ADD setupReplicaSet1.js /setupReplicaSet1.js
ADD setupReplicaSet2.js /setupReplicaSet2.js
ADD setupReplicaSet3.js /setupReplicaSet3.js
ADD addShard.js /addShard.js
ADD addDB.js /addDB.js
ADD enabelSharding.js /enabelSharding.js
ADD start /start
RUN chmod 0755 /start /*.js

CMD ["/start"]