ARG MACHINE
ARG BOOT_DEV_PART
ARG UBOOT_ENV_SIZE
ARG NETWORK_INTERFACE
ARG NETWORK_DHCP
ARG KERNEL_IMAGE

COPY machine/files/fstab.in /etc/fstab
COPY machine/files/fw_env.config.in /etc/fw_env.config
COPY machine/files/interfaces.in /etc/network/interfaces
ADD machine/$MACHINE/kernel-modules-*.tar.gz /usr/lib/modules
ADD machine/$MACHINE/kernel-artifacts-*.tar.gz /boot

RUN sed -i "s/@@BOOT_DEV@@/${BOOT_DEV_PART}/" /etc/fstab
RUN sed -i "s/@@ENV_SIZE@@/${UBOOT_ENV_SIZE}/" /etc/fw_env.config
RUN if [[ -n "$NETWORK_INTERFACE" ]]; then \
      echo "auto $NETWORK_INTERFACE" >> /etc/network/interfaces && \
      if [[ "$NETWORK_DHCP" == "true" ]]; then \
        echo "iface $NETWORK_INTERFACE inet dhcp" >> /etc/network/interfaces; \
      fi \
    fi

# install rpi firmware
RUN if [[ "$MACHINE" == "raspberry-pi-3" ]]; then \
      apk add --no-cache linux-firmware-brcm; \
    fi

# install kernel and dummy initramfs to ostree location
RUN K_VER=$(ls /usr/lib/modules) && \
    cp /boot/$KERNEL_IMAGE /usr/lib/modules/$K_VER/vmlinuz && \
    touch /usr/lib/modules/$K_VER/initramfs.img && \
    rm -rf boot
