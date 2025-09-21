# Build rust-$RUST_VERSION-i586-unknown-linux-gnu.tar.gz
ARCHITECTURE=x86
BUSYBOX_VERSION="1.36.1"
MARCH="i686"
MTUNE="i686"
TCL_VERSION=16.x

all: edit compile

edit:
	scripts/edit-config.sh ${ARCHITECTURE} ${BUSYBOX_VERSION} ${MARCH} ${MTUNE} ${TCL_VERSION}

compile:
	scripts/compile.sh ${ARCHITECTURE} ${BUSYBOX_VERSION} ${MARCH} ${MTUNE} ${TCL_VERSION}

publish:
	tools/publish.sh ${BUSYBOX_VERSION}

