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
MARCH=$2
MTUNE=$3

BUSYBOX_PACKAGE_NAME="busybox-$BUSYBOX_VERSION"

COMPILATION_DIRECTORY=/home/tc/busybox
CONFIGURATION_DIRECTORY=$COMPILATION_DIRECTORY/configuration
RELEASE_DIRECTORY=$COMPILATION_DIRECTORY/release
BUSYBOX_SOURCES_DIRECTORY=$COMPILATION_DIRECTORY/$BUSYBOX_PACKAGE_NAME
cd $BUSYBOX_SOURCES_DIRECTORY

patch -Np1 -i $COMPILATION_DIRECTORY/patches/busybox-1.27.1-wget-make-default-timeout-configurable.patch
patch -Np1 -i $COMPILATION_DIRECTORY/patches/busybox-1.29.3_root_path.patch
patch -Np1 -i $COMPILATION_DIRECTORY/patches/busybox-1.33.0_modprobe.patch
patch -Np0 -i $COMPILATION_DIRECTORY/patches/busybox-1.33.0_tc_depmod.patch
patch -Np0 -i $COMPILATION_DIRECTORY/patches/busybox-1.36.1-check-lxdialog.patch

