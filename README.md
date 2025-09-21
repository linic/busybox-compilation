# BusyBox Compilation
WORK IN PROGRESS
Compiling BusyBox for use with Tiny Core Linux and possibly more.

Compilation is inspired from config files and compile scripts found [here on tinycorelinux.net](http://tinycorelinux.net/15.x/x86/release/src/busybox/)
Mainly
- [compile_busybox](http://tinycorelinux.net/15.x/x86/release/src/busybox/compile_busybox)
- [busybox-1.36.1_config_suid](http://tinycorelinux.net/15.x/x86/release/src/busybox/busybox-1.36.1_config_suid)
- [busybox-1.36.1_config_nosuid](http://tinycorelinux.net/15.x/x86/release/src/busybox/busybox-1.36.1_config_nosuid)

## [configuration](./configuration)
The configuration files to build busybox originally came from http://tinycorelinux.net/15.x/x86/release/src/busybox/
They were modified using `make menuconfig`.

## [patches](./patches)
The patches were copied from http://tinycorelinux.net/15.x/x86/release/src/busybox/

