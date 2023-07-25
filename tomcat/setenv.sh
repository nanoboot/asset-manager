# place in /bin directory of Tomcat installation

ASSET_MANAGER_CONFPATH="{path to confpath directory}"

export JAVA_OPTS="$JAVA_OPTS -Dasset-manager.confpath=${ASSET_MANAGER_CONFPATH} -Dasset-manager.allcanupdate=false -Dasset-manager.loginrequiredtoread=false"

