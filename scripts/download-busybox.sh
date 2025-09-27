#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/busybox-compilation                    #
###################################################################

###################################################################
# Download BusyBox.                                               #
###################################################################

set -e
trap 'echo "Error on line $LINENO"' ERR

BUSYBOX_VERSION=$1
MARCH=$2
MTUNE=$3

BUSYBOX_PACKAGE_NAME="busybox-$BUSYBOX_VERSION"

COMPILATION_DIRECTORY=/home/tc/busybox
CONFIGURATION_DIRECTORY=$COMPILATION_DIRECTORY/configuration
RELEASE_DIRECTORY=$COMPILATION_DIRECTORY/release
BUSYBOX_SOURCES_DIRECTORY=$COMPILATION_DIRECTORY/$BUSYBOX_PACKAGE_NAME

mkdir -pv $COMPILATION_DIRECTORY
cd $COMPILATION_DIRECTORY

curl --remote-name https://busybox.net/downloads/$BUSYBOX_PACKAGE_NAME.tar.bz2
bzip2 -d -k $BUSYBOX_PACKAGE_NAME.tar.bz2
tar x -f $BUSYBOX_PACKAGE_NAME.tar
cd $BUSYBOX_SOURCES_DIRECTORY

