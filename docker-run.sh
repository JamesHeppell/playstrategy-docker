#!/bin/bash

docker run \
    --mount type=bind,source=$HOME/dev/playstrategy,target=/home/playstrategy/projects \
    --publish 9663:9663 \
    --publish 9664:9664 \
    --publish 8210:8210 \
    --name playstrategy2 \
    --interactive \
    --tty \
    --memory=6g \
    --memory-swap=6g \
    -e JAVA_OPTS='-Xmx3g -Dcom.sun.management.jmxremote -Dcom.sun.management.jmxremote.port=9010 -Dcom.sun.management.jmxremote.local.only=false -Dcom.sun.management.jmxremote.authenticate=false -Dcom.sun.management.jmxremote.ssl=false' \
    -p 9010:9010 \
    playstrategy2
