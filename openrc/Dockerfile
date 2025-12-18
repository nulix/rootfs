ARG MACHINE
ARG VIRT_BACKEND
ARG SERIAL_PORT
ARG SERIAL_BAUD

RUN apk add --no-cache openrc openrc-init agetty agetty-openrc

# set openrc-init as the init system
RUN cd /sbin && \
    ln -sf openrc-init init

# openrc-init does not use /etc/inittab
RUN rm /etc/inittab

# enable serial console
RUN cd /etc/conf.d && \
    cp agetty agetty.$SERIAL_PORT && \
    sed -i "s/^#baud=\"\"/baud=\"$SERIAL_BAUD\"/" agetty.$SERIAL_PORT && \
    cd /etc/init.d && \
    ln -s agetty agetty.$SERIAL_PORT

# install openrc-init reboot and poweroff scripts
COPY openrc/openrc-init/poweroff.in /sbin/
COPY openrc/openrc-init/reboot.in /sbin/
RUN mv /sbin/poweroff.in /sbin/poweroff && \
    mv /sbin/reboot.in /sbin/reboot && \
    chmod +x /sbin/poweroff && \
    chmod +x /sbin/reboot

# custom services
COPY openrc/tmpfiles/tmpfiles.initd /etc/init.d/tmpfiles
COPY openrc/resize-rootfs/resize-rootfs.initd /etc/init.d/resize-rootfs

# add services to runlevels, in this order: sysinit, boot, default, shutdown
RUN rc-update add dmesg sysinit
RUN rc-update add hwdrivers sysinit
RUN rc-update add mdev sysinit
RUN rc-update add resize-rootfs sysinit
RUN rc-update add tmpfiles sysinit
RUN rc-update add chronyd boot
RUN rc-update add $VIRT_BACKEND boot || true
RUN rc-update add hostname boot
RUN if [[ "$MACHINE_HAS_RTC" == "true" ]]; then \
      rc-update add hwclock boot; \
    fi
RUN rc-update add modules boot
RUN rc-update add networking boot
RUN rc-update add sysctl boot
RUN rc-update add agetty.$SERIAL_PORT default
RUN rc-update add killprocs shutdown
RUN rc-update add mount-ro shutdown
