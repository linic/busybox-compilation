#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/busybox-compilation                    #
###################################################################

###################################################################
# Edit the compilation configuration for BusyBox.                 #
# This is an alternate build which has less features than the     #
# official BusyBox shipped with Tiny Core Linux.                  #
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

mkdir -pv $COMPILATION_DIRECTORY
cd $COMPILATION_DIRECTORY

curl --remote-name https://busybox.net/downloads/$BUSYBOX_PACKAGE_NAME.tar.bz2
bzip2 --decompress --keep $BUSYBOX_PACKAGE_NAME.tar.bz2
tar x -f $BUSYBOX_PACKAGE_NAME.tar

# Edit the config for the first compilation with suid
cp $CONFIGURATION_DIRECTORY/config-suid .config
make oldconfig
make menuconfig
cp .config $CONFIGURATION_DIRECTORY/config-suid

# Edit the config for the second compilation with nosuid
cp /home/tc/${BUSYBOX_PACKAGE_NAME}_config_nosuid .config
make oldconfig
make menuconfig
cp .config /home/tc/${BUSYBOX_PACKAGE_NAME}_config_nosuid
