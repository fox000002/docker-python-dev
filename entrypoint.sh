#!/bin/bash

/root/mongodb-linux-x86_64-amazon2-4.0.6/bin/mongod --bind_ip_all --dbpath /root/data --fork --logpath /var/log/mongo.log

exec $1
