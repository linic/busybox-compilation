# Build rust-$RUST_VERSION-i586-unknown-linux-gnu.tar.gz
ARCHITECTURE=x86
BUSYBOX_VERSION="1.36.1"
MARCH="i686"
MTUNE="i686"
TCL_VERSION=16.x

all: edit-suid edit-nosuid compile-suid compile-nosuid

edit-suid:
	scripts/edit-config.sh ${ARCHITECTURE} ${BUSYBOX_VERSION} suid ${MARCH} ${MTUNE} ${TCL_VERSION}

edit-nosuid:
	scripts/edit-config.sh ${ARCHITECTURE} ${BUSYBOX_VERSION} nosuid ${MARCH} ${MTUNE} ${TCL_VERSION}

compile-suid:
	scripts/compile.sh ${ARCHITECTURE} ${BUSYBOX_VERSION} suid ${MARCH} ${MTUNE} ${TCL_VERSION}

compile-nosuid:
	scripts/compile.sh ${ARCHITECTURE} ${BUSYBOX_VERSION} nosuid ${MARCH} ${MTUNE} ${TCL_VERSION}

publish:
	tools/publish.sh ${BUSYBOX_VERSION}

