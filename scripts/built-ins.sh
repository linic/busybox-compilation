#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/busybox-compilation                    #
###################################################################

###################################################################
# Generate a file with a list of paths which will have to exist   #
# when repackaging core.gz later.                                 #
###################################################################

# Usage: ./generate_update_script.sh core.gz.all_paths.txt busybox-1.36.1-suid.candidates.file
CORE_GZ_PATHS="$1"
# Using the .candidates.files, it's possible to know which feature were built into this busybox.
CANDIDATES="$2"
BUSYBOX_NAME="busybox.suid"
echo "$CANDIDATES" | grep -q "nosuid"
# Check the exit status of the last command.
if [ $? -eq 0 ]; then
  BUSYBOX_NAME="busybox"
fi
OUTPUT="$BUSYBOX_NAME.built-ins.txt"
rm $OUTPUT
grep "/release/" "$CANDIDATES" | while read -r FILE; do
    NAME=$(basename "$FILE")
    DIR=$(dirname "$FILE" | sed "s|.*/release||")   # e.g. /sbin
    COREPATH=".$DIR/$NAME"
    echo "$COREPATH" >> $OUTPUT
done

