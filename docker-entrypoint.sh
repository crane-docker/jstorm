#!/bin/bash

set -e

# Allow the container to be started with `--user`
if [ "$1" = 'jstorm' -a "$(id -u)" = '0' ]; then
    chown -R "$JSTORM_USER" "$JSTORM_DATA_DIR" "$JSTORM_LOG_DIR"
    exec su-exec "$JSTORM_USER" "$0" "$@"
fi

# Generate the config only if it doesn't exist
CONFIG="$JSTORM_HOME/conf/storm.yaml"
if [ ! -f "$CONFIG" ]; then
    cat << EOF > "$CONFIG"
storm.zookeeper.servers: [zookeeper]
nimbus.seeds: [nimbus]
# storm.log.dir: "$JSTORM_LOG_DIR"
# storm.local.dir: "$JSTORM_DATA_DIR"
EOF
fi

exec "$@"
