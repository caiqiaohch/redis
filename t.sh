#!/bin/bash
 sudo REDIS_PORT=1234 \
 		 REDIS_CONFIG_FILE=/etc/redis/1234.conf \
 		 REDIS_LOG_FILE=/var/log/redis_1234.log \
		 REDIS_DATA_DIR=/var/lib/redis/1234 \
		 REDIS_EXECUTABLE=`command -v redis-server` ./utils/install_server.sh




# Welcome to the redis service installer
# This script will help you easily set up a running redis server

# Selected config:
# Port           : 1234
# Config file    : /etc/redis/1234.conf
# Log file       : /var/log/redis_1234.log
# Data dir       : /var/lib/redis/1234
# Executable     : /usr/bin/redis-server
# Cli Executable : /usr/bin/redis-cli
# Copied /tmp/1234.conf => /etc/init.d/redis_1234
# Installing service...
# Success!
# Starting Redis server...
# Installation successful!