#!/bin/sh

PRINT_TIME="date +%d.%m.%y_%H:%M:%S"
echo Starting Docker container at `${PRINT_TIME}`...

ASSET_MANAGER_CONFPATH="/usr/local/asset-manager.confpath"

export JAVA_OPTS="$JAVA_OPTS -Dasset-manager.confpath=${ASSET_MANAGER_CONFPATH}"

catalina.sh run


