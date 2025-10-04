#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/busybox-compilation                    #
###################################################################

##################################################################
# Edit BusyBox .config.                                          #
##################################################################

CONFIGURATION_DIRECTORY=/home/tc/busybox/configuration

PARAMETER_ERROR_MESSAGE="ARCHITECTURE BUSYBOX_VERSION CONFIG_TYPE MARCH MTUNE TCL_VERSION are required. For example: ./edit-config.sh x86 1.36.1 suid i686 i686 16.x"
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

if [ ! -f docker-compose.edit-config-$CONFIG_TYPE.yml ] || ! grep -q "$ARCHITECTURE" docker-compose.edit-config-$CONFIG_TYPE.yml || ! grep -q "$BUSYBOX_VERSION" docker-compose.edit-config-$CONFIG_TYPE.yml || ! grep -q "$CONFIG_TYPE" docker-compose.edit-config-$CONFIG_TYPE.yml || ! grep -q "$MARCH" docker-compose.edit-config-$CONFIG_TYPE.yml || ! grep -q "$MTUNE" docker-compose.edit-config-$CONFIG_TYPE.yml || ! grep -q "$TCL_VERSION" docker-compose.edit-config-$CONFIG_TYPE.yml; then
  echo "Did not find $ARCHITECTURE, $BUSYBOX_VERSION, $MARCH, $MTUNE or $TCL_VERSION in docker-compose.edit-config-$CONFIG_TYPE.yml. Rewriting docker-compose.edit-config-$CONFIG_TYPE.yml."
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
    "       - linichotmailca/busybox-compilation:$BUSYBOX_VERSION-edit-$CONFIG_TYPE\n"\
    "       - linichotmailca/busybox-compilation:latest-edit-$CONFIG_TYPE\n"\
    "     dockerfile: Dockerfile.edit-config\n" > docker-compose.edit-config-$CONFIG_TYPE.yml
fi

if sudo docker compose --progress=plain -f docker-compose.edit-config-$CONFIG_TYPE.yml build; then
  echo "Build succeeded."
else
  echo "Build failed!"
  exit 3
fi

mkdir -p ./release/$BUSYBOX_VERSION/
sudo docker compose --progress=plain -f docker-compose.edit-config-$CONFIG_TYPE.yml up --detach

BUSYBOX_PACKAGE_NAME="busybox-$BUSYBOX_VERSION"
COMPILATION_DIRECTORY=/home/tc/busybox
CONFIGURATION_DIRECTORY=$COMPILATION_DIRECTORY/configuration
RELEASE_DIRECTORY=$COMPILATION_DIRECTORY/release
BUSYBOX_SOURCES_DIRECTORY=$COMPILATION_DIRECTORY/$BUSYBOX_PACKAGE_NAME
sudo docker exec -it busybox-compilation-main-1 $COMPILATION_DIRECTORY/scripts/edit-busybox-config-interactive.sh $BUSYBOX_VERSION $CONFIG_TYPE

sudo docker cp busybox-compilation-main-1:$CONFIGURATION_DIRECTORY/config-$CONFIG_TYPE  ./release/$BUSYBOX_VERSION/config-$CONFIG_TYPE
sudo docker cp busybox-compilation-main-1:$CONFIGURATION_DIRECTORY/config-$CONFIG_TYPE  ./configuration/config-$CONFIG_TYPE
sudo docker compose --progress=plain -f docker-compose.edit-config-$CONFIG_TYPE.yml down
