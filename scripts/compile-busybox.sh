#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/busybox-compilation                    #
###################################################################

###################################################################
# Compile BusyBox.                                                #
# This is an alternate build which has less features than the     #
# official BusyBox shipped with Tiny Core Linux.                  #
###################################################################

set -e
trap 'echo "Error on line $LINENO"' ERR

BUSYBOX_VERSION=$1
CONFIG_TYPE=$2
MARCH=$3
MTUNE=$4

BUSYBOX_PACKAGE_NAME="busybox-$BUSYBOX_VERSION"

COMPILATION_DIRECTORY=/home/tc/busybox
CONFIGURATION_DIRECTORY=$COMPILATION_DIRECTORY/configuration
RELEASE_DIRECTORY=/home/tc/busybox/release
mkdir -pv $COMPILATION_DIRECTORY

cd $COMPILATION_DIRECTORY

curl --remote-name https://busybox.net/downloads/$BUSYBOX_PACKAGE_NAME.tar.bz2
bzip2 -d -k $BUSYBOX_PACKAGE_NAME.tar.bz2
tar x -f $BUSYBOX_PACKAGE_NAME.tar
cd $BUSYBOX_PACKAGE_NAME

patch -Np1 -i $COMPILATION_DIRECTORY/patches/busybox-1.27.1-wget-make-default-timeout-configurable.patch
patch -Np1 -i $COMPILATION_DIRECTORY/patches/busybox-1.29.3_root_path.patch
patch -Np1 -i $COMPILATION_DIRECTORY/patches/busybox-1.33.0_modprobe.patch
patch -Np0 -i $COMPILATION_DIRECTORY/patches/busybox-1.33.0_tc_depmod.patch
patch -Np0 -i $COMPILATION_DIRECTORY/patches/busybox-1.36.1-check-lxdialog.patch

cp $CONFIGURATION_DIRECTORY/config-$CONFIG_TYPE .config
make CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti"
touch $BUSYBOX_PACKAGE_NAME.time-marker
make CC="gcc -flto -march=$MARCH -mtune=$MTUNE -Os -pipe" CXX="g++ -flto -march=$MARCH -mtune=$MTUNE -Os -pipe -fno-exceptions -fno-rtti" CONFIG_PREFIX=$RELEASE_DIRECTORY install
touch $BUSYBOX_PACKAGE_NAME.candidates.files
find / -not -type 'd' -cnewer $BUSYBOX_PACKAGE_NAME.time-marker | grep -v "\/proc\/" | grep -v "^\/sys\/" | tee -a $BUSYBOX_PACKAGE_NAME.candidates.files

if [ $CONFIG_TYPE -eq "suid" ]; then
  mv $RELEASE_DIRECTORY/bin/busybox $RELEASE_DIRECTORY/busybox.suid
  echo "Making busybox binary setuid root"
  chmod u+s $RELEASE_DIRECTORY/busybox.suid
else
  mv $RELEASE_DIRECTORY/bin/busybox $RELEASE_DIRECTORY/busybox
fi
