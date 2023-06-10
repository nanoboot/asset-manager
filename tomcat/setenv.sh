# place in /bin directory of Tomcat installation

COLOR_SHAPES_ARCHIVE_CONFPATH="{path to confpath directory}"

export JAVA_OPTS="$JAVA_OPTS -Dasset-manager.confpath=${COLOR_SHAPES_ARCHIVE_CONFPATH} -Dasset-manager.allcanupdate=false"

