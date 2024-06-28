#!/bin/bash

source /home/playstrategy/.bashrc

# Run Redis in the background.
redis-server --daemonize yes

# Run lila-ws in the background.
# cd /home/playstrategy/projects/lila-ws
# setsid nohup sbt run &

# Run MongoDB in the background.
sudo mongod --fork --logpath /var/log/mongod.log

cd /home/playstrategy/projects/lila

# Update the client side modules.
# ./ui/build

# Run the Scala application
# ./lila run

bash
