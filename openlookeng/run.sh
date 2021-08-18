#!/bin/bash
set -e

export IS_COORDINATOR=true
export INCLUDE_COORDINATOR=true
export HTTP_PORT=8001
export DISCOVERY_URI=http://0.0.0.0:8001
export NODE_ENVIRONMENT=hc

IS_COORDINATOR=${IS_COORDINATOR:-""}
if [ "$IS_COORDINATOR" == "true" ]; then
    echo "coordinator=true" >> etc/config.properties
    echo "discovery-server.enabled=true" >> etc/config.properties
else
    echo "coordinator=false" >> etc/config.properties
fi

INCLUDE_COORDINATOR={INCLUDE_COORDINATOR:-""}
if [ "$INCLUDE_COORDINATOR" == "true" ]; then
    echo "node-scheduler.include-coordinator=true" >> etc/config.properties
fi

echo "http-server.http.port=$HTTP_PORT" >> etc/config.properties
echo "discovery.uri=$DISCOVERY_URI" >> etc/config.properties
echo "hetu.queryeditor-ui.allow-insecure-over-http=true" >> etc/config.properties
echo "node.environment=$NODE_ENVIRONMENT" >> etc/node.properties
echo "node.id=$(cat /proc/sys/kernel/random/uuid)" >> etc/node.properties

/home/openlkadmin/hetu-server/bin/launcher run