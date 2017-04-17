#!/bin/bash

set -e

# Generate the config only if it doesn't exist
CONFIG="$JSTORM_HOME/conf/storm.yaml"
if [ ! -f "$CONFIG" ]; then
    cat << EOF > "$CONFIG"
storm.zookeeper.servers: [zookeeper]
nimbus.seeds: [nimbus]
storm.log.dir: "$JSTORM_LOG_DIR"
storm.local.dir: "$JSTORM_DATA_DIR"
EOF
fi

exec "$@"
