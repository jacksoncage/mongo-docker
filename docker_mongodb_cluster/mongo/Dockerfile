FROM        ubuntu:14.04.1
MAINTAINER  Love Nyberg "love@bloglovin.com"
ENV REFRESHED_AT 2014-10-18

# Add 10gen official apt source to the sources list
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/ubuntu-upstart dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list

# Install MongoDB
RUN apt-get update -qq && \
  apt-get upgrade -yqq && \
  apt-get -yqq install mongodb-org && \
  apt-get -yqq clean

# Create the MongoDB data directory
RUN mkdir -p /data/db

EXPOSE 27017

ADD js/initiate.js /initiate.js
ADD js/setupReplicaSet1.js /setupReplicaSet1.js
ADD js/setupReplicaSet2.js /setupReplicaSet2.js
ADD js/setupReplicaSet3.js /setupReplicaSet3.js
ADD js/addShard.js /addShard.js
ADD js/addDBs.js /addDBs.js
ADD js/enabelSharding.js /enabelSharding.js
ADD js/addIndexes.js /addIndexes.js
ADD start.sh /start.sh

CMD ["/start.sh"]
