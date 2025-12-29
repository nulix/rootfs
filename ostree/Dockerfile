###
### INSPIRED WITH:
###
# https://github.com/uptane/meta-updater/blob/master/classes/image_types_ostree.bbclass

ARG MACHINE
ARG HOSTNAME
ARG VIRT_TECH
ARG DISTRO_VERSION_MAJOR
ARG OSTREE_BRANCHNAME="$DISTRO_VERSION_MAJOR/stable/$MACHINE"

# install and start the service
COPY ostree/files/touch-ostree.initd /etc/init.d/touch-ostree
RUN rc-update add touch-ostree default

# install build deps
RUN apk add --no-cache ostree patchelf

# placeholder for ostree boot files
RUN mkdir boot

# replicate usrmerge
RUN mkdir -p /usr/bin && \
    mv /bin/* /usr/bin
SHELL ["/usr/bin/busybox", "sh", "-c"]
RUN /usr/bin/busybox rm -rf /bin && \
    /usr/bin/busybox ln -s usr/bin /bin
RUN mkdir -p /usr/sbin && \
    mv /sbin/* /usr/sbin && \
    rm -rf /sbin && \
    ln -s usr/sbin /sbin
RUN mkdir -p /usr/lib && \
    cp -a /lib/* /usr/lib && \
    cp /usr/bin/busybox /tmp && \
    patchelf --set-interpreter /usr/lib/ld-musl-*.so.* /tmp/busybox
SHELL ["/tmp/busybox", "sh", "-c"]
RUN rm -rf /lib && \
    /tmp/busybox ln -s usr/lib /lib && \
    apk del patchelf
RUN if [ -d /lib64 ]; then \
    mkdir -p /usr/lib64; \
    cp -a /lib64/* /usr/lib64; \
    rm -rf /lib64; \
    ln -s usr/lib64 /lib64; \
    fi
SHELL ["/bin/busybox", "sh", "-c"]
RUN rm /tmp/busybox

# preserve var/lib/$VIRT_TECH
RUN if [ -d var/lib/$VIRT_TECH ]; then \
    mv var/lib/$VIRT_TECH var-lib-$VIRT_TECH; \
    fi

# preserve var/local
RUN if [ -d var/local ]; then \
    mv var/local var-local; \
    fi

# completely remove var
RUN rm -rf var/lib && \
    rm -rf var/cache && \
    rm -rf var && \
    mkdir var

# get back var/local
RUN if [ -d var-local ]; then \
    mv var-local var/local; \
    fi

# get back var/lib/$VIRT_TECH
RUN if [ -d var-lib-$VIRT_TECH ]; then \
    mkdir var/lib; \
    mv var-lib-$VIRT_TECH var/lib/$VIRT_TECH; \
    fi

# create sysroot directory to which physical sysroot will be mounted
RUN mkdir sysroot && \
    ln -sf sysroot/ostree ostree && \
    mkdir -p usr/rootdirs && \
    mv etc usr/ || true
# [workaround]: do not exit on the following error, cleanup this
# in the Dockerfile.ostree_repo instead, before the first commit
# > [2/2] RUN mv /etc /usr:
# 1.915 mv: can't remove '/etc/resolv.conf': Device or resource busy
# 1.915 mv: can't remove '/etc/hosts': Device or resource busy

# workaround hostname issue
RUN cd usr/etc && \
    echo -n "$HOSTNAME" > hostname

# make this symlink otherwise '/etc/resolv.conf' will be reported
# as modified when running `ostree admin config-diff` because
# it will eventually be updated in the runtime
RUN cd usr/etc && \
    ln -sf /run/resolv.conf resolv.conf

# preserve OSTREE_BRANCHNAME for future information
RUN mkdir -p usr/share/sota/ && \
    echo -n "${OSTREE_BRANCHNAME}" > usr/share/sota/branchname

# create a symlink to var/rootdirs/home to make sure the OSTree deployment
# redirects /home to /var/rootdirs/home
RUN mkdir -p var/rootdirs && \
    mv home var/rootdirs && \
    rm -rf home && \
    ln -sf var/rootdirs/home home

RUN DIRS="media mnt opt srv" && \
    for dir in ${DIRS}; do \
    rm -rf /${dir}; \
    ln -sf var/rootdirs/${dir} ${dir}; \
    done

RUN mv root var/roothome && \
    rm -rf root && \
    ln -sf var/roothome root

RUN rm -rf usr/local

RUN ln -sf ../var/usrlocal usr/local

# copy image manifest
RUN cat ${IMAGE_MANIFEST} | cut -d " " -f1,3 > usr/package.manifest
