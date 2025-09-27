#!/bin/sh

###################################################################
# Copyright (C) 2025  linic@hotmail.ca Subject to GPL-3.0 license.#
# https://github.com/linic/busybox-compilation                    #
###################################################################

##################################################################
# Required .tcz to be able to compile busybox.                   #
# There may be too much stuff here since I quickly picked the requirements from
# https://raw.githubusercontent.com/linic/tcl-core-560z/refs/heads/main/tools/tce-load-requirements.sh #
# https://raw.githubusercontent.com/linic/rust-i586/refs/heads/main/tools/tce-load-build-requirements.sh #
##################################################################

tce-load -wi bash
tce-load -wi perl5
tce-load -wi curl
tce-load -wi ncursesw-dev
tce-load -wi cmake.tcz compiletc.tcz gcc.tcz git.tcz zlib_base-dev.tcz openssl-dev.tcz openssl.tcz curl.tcz ninja.tcz python3.9.tcz

