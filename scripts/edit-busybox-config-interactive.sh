#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/busybox-compilation                    #
###################################################################

###################################################################
# Edit the compilation configuration for BusyBox.                 #
# This is an alternate build which has less features than the     #
# official BusyBox shipped with Tiny Core Linux.                  #
# This script relies on download-busybox.sh being called first.   #
###################################################################

set -e
trap 'echo "Error on line $LINENO"' ERR

BUSYBOX_VERSION=$1
CONFIG_TYPE=$2

BUSYBOX_PACKAGE_NAME="busybox-$BUSYBOX_VERSION"

COMPILATION_DIRECTORY=/home/tc/busybox
CONFIGURATION_DIRECTORY=$COMPILATION_DIRECTORY/configuration
RELEASE_DIRECTORY=$COMPILATION_DIRECTORY/release
BUSYBOX_SOURCES_DIRECTORY=$COMPILATION_DIRECTORY/$BUSYBOX_PACKAGE_NAME

cd $BUSYBOX_SOURCES_DIRECTORY
make menuconfig
cp .config $CONFIGURATION_DIRECTORY/config-$CONFIG_TYPE
