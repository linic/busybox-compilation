ARG ARCHITECTURE
ARG BUSYBOX_VERSION
ARG MARCH
ARG MTUNE
ARG TCL_VERSION
FROM linichotmailca/tcl-core-x86:$TCL_VERSION-$ARCHITECTURE
ARG BUSYBOX_VERSION
ARG MARCH
ARG MTUNE
WORKDIR /home/tc/busybox/
RUN mkdir -p /home/tc/busybox/scripts
COPY --chown=tc:staff scripts/tce-load-build-requirements.sh /home/tc/busybox/scripts/
RUN /home/tc/busybox/scripts/tce-load-build-requirements.sh
COPY --chown=tc:staff scripts/compile-busybox.sh /home/tc/busybox/scripts/
RUN mkdir -p /home/tc/busybox/configuration
COPY --chown=tc:staff configuration/config-suid /home/tc/busybox/configuration/
COPY --chown=tc:staff configuration/config-nosuid /home/tc/busybox/configuration/
COPY --chown=tc:staff patches /home/tc/busybox/patches
RUN /home/tc/busybox/scripts/compile-busybox.sh $BUSYBOX_VERSION $MARCH $MTUNE
COPY --chown=tc:staff scripts/echo_sleep.sh /home/tc/busybox/scripts/
ENTRYPOINT ["/bin/sh", "/home/tc/busybox/scripts/echo_sleep.sh"]

