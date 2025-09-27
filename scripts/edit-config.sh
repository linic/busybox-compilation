#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/busybox-compilation                    #
###################################################################

##################################################################
# Edit BusyBox .config.                                          #
##################################################################

CONFIGURATION_DIRECTORY=/home/tc/busybox/configuration

PARAMETER_ERROR_MESSAGE="ARCHITECTURE BUSYBOX_VERSION MARCH MTUNE TCL_VERSION are required. For example: ./edit-config.sh x86 1.36.1 i686 i686 16.x"
if [ ! $# -eq 5 ]; then
  echo $PARAMETER_ERROR_MESSAGE
  exit 1
fi
ARCHITECTURE=$1
if [ $ARCHITECTURE != "x86" ]; then
  echo "ARCHITECTURE can only be x86 for now."
  exit 2
fi
BUSYBOX_VERSION=$2
MARCH=$3
MTUNE=$4
TCL_VERSION=$5

if [ ! -f docker-compose.edit-config.yml ] || ! grep -q "$ARCHITECTURE" docker-compose.edit-config.yml || ! grep -q "$BUSYBOX_VERSION" docker-compose.edit-config.yml || ! grep -q "$MARCH" docker-compose.edit-config.yml || ! grep -q "$MTUNE" docker-compose.edit-config.yml || ! grep -q "$TCL_VERSION" docker-compose.edit-config.yml; then
  echo "Did not find $ARCHITECTURE, $BUSYBOX_VERSION, $MARCH, $MTUNE or $TCL_VERSION in docker-compose.edit-config.yml. Rewriting docker-compose.edit-config.yml."
  echo "services:\n"\
    " main:\n"\
    "   build:\n"\
    "     context: .\n"\
    "     args:\n"\
    "       - ARCHITECTURE=$ARCHITECTURE\n"\
    "       - BUSYBOX_VERSION=$BUSYBOX_VERSION\n"\
    "       - MARCH=$MARCH\n"\
    "       - MTUNE=$MTUNE\n"\
    "       - TCL_VERSION=$TCL_VERSION\n"\
    "     tags:\n"\
    "       - linichotmailca/busybox-compilation:$BUSYBOX_VERSION-edit\n"\
    "       - linichotmailca/busybox-compilation:latest-edit\n"\
    "     dockerfile: Dockerfile.edit-config\n" > docker-compose.edit-config.yml
fi

if sudo docker compose --progress=plain -f docker-compose.edit-config.yml build; then
  echo "Build succeeded."
else
  echo "Build failed!"
  exit 3
fi

mkdir -p ./release/$BUSYBOX_VERSION/
sudo docker compose --progress=plain -f docker-compose.edit-config.yml up --detach
sudo docker cp busybox-compilation-main-1:$CONFIGURATION_DIRECTORY/config-suid  ./release/$BUSYBOX_VERSION/config-suid
sudo docker cp busybox-compilation-main-1:$CONFIGURATION_DIRECTORY/config-nosuid  ./release/$BUSYBOX_VERSION/config-nosuid
sudo docker compose --progress=plain -f docker-compose.edit-config.yml down
