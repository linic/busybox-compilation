#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/busybox-compilation                    #
###################################################################

##################################################################
# Compile BusyBox.                                               #
##################################################################

PARAMETER_ERROR_MESSAGE="ARCHITECTURE BUSYBOX_VERSION CONFIG_TYPE MARCH MTUNE TCL_VERSION are required. For example: ./compile.sh x86 1.36.1 suid i686 i686 16.x"
if [ ! $# -eq 6 ]; then
  echo $PARAMETER_ERROR_MESSAGE
  exit 1
fi
ARCHITECTURE=$1
if [ $ARCHITECTURE != "x86" ]; then
  echo "ARCHITECTURE can only be x86 for now."
  exit 2
fi
BUSYBOX_VERSION=$2
CONFIG_TYPE=$3
MARCH=$4
MTUNE=$5
TCL_VERSION=$6

if [ ! -f docker-compose.compile-$CONFIG_TYPE.yml ] || ! grep -q "$ARCHITECTURE" docker-compose.compile-$CONFIG_TYPE.yml || ! grep -q "$BUSYBOX_VERSION" docker-compose.compile-$CONFIG_TYPE.yml ||  ! grep -q "$CONFIG_TYPE" docker-compose.compile-$CONFIG_TYPE.yml || ! grep -q "$MARCH" docker-compose.compile-$CONFIG_TYPE.yml || ! grep -q "$MTUNE" docker-compose.compile-$CONFIG_TYPE.yml || ! grep -q "$TCL_VERSION" docker-compose.compile-$CONFIG_TYPE.yml; then
  echo "Did not find $ARCHITECTURE, $BUSYBOX_VERSION, $MARCH, $MTUNE or $TCL_VERSION in docker-compose.compile-$CONFIG_TYPE.yml. Rewriting docker-compose.compile-$CONFIG_TYPE.yml."
  echo "services:\n"\
    " main:\n"\
    "   build:\n"\
    "     context: .\n"\
    "     args:\n"\
    "       - ARCHITECTURE=$ARCHITECTURE\n"\
    "       - BUSYBOX_VERSION=$BUSYBOX_VERSION\n"\
    "       - CONFIG_TYPE=$CONFIG_TYPE\n"\
    "       - MARCH=$MARCH\n"\
    "       - MTUNE=$MTUNE\n"\
    "       - TCL_VERSION=$TCL_VERSION\n"\
    "     tags:\n"\
    "       - linichotmailca/busybox-compilation:$BUSYBOX_VERSION-$CONFIG_TYPE\n"\
    "       - linichotmailca/busybox-compilation:latest-$CONFIG_TYPE\n"\
    "     dockerfile: Dockerfile\n" > docker-compose.compile-$CONFIG_TYPE.yml
fi

if sudo docker compose --progress=plain -f docker-compose.compile-$CONFIG_TYPE.yml build; then
  echo "Build succeeded."
else
  echo "Build failed!"
  exit 3
fi

mkdir -p ./release/$BUSYBOX_VERSION/

SOURCE_RELEASE_DIRECTORY=/home/tc/busybox/release
SOURCE_NOSUID=$SOURCE_RELEASE_DIRECTORY/busybox
SOURCE_SUID=$SOURCE_NOSUID.suid
TARGET_RELEASE_DIRECTORY=./release/$BUSYBOX_VERSION
TARGET_NOSUID=$TARGET_RELEASE_DIRECTORY/busybox
TARGET_SUID=$TARGET_NOSUID.suid

sudo docker compose --progress=plain -f docker-compose.compile-$CONFIG_TYPE.yml up --detach
if [ $CONFIG_TYPE != "suid" ]; then
  sudo docker cp busybox-compilation-main-1:$SOURCE_NOSUID $TARGET_NOSUID
  sha512sum $TARGET_NOSUID > $TARGET_NOSUID.sha512.txt
  md5sum $TARGET_NOSUID > $TARGET_NOSUID.md5.txt
  gpg --detach-sign $TARGET_NOSUID
else
  sudo docker cp busybox-compilation-main-1:$SOURCE_SUID $TARGET_SUID
  sha512sum $TARGET_SUID > $TARGET_SUID.sha512.txt
  md5sum $TARGET_SUID > $TARGET_SUID.md5.txt
  gpg --detach-sign $TARGET_SUID
fi
sudo docker compose --progress=plain -f docker-compose.compile-$CONFIG_TYPE.yml down

