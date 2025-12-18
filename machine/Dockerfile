ARG MACHINE
ARG NULIX_VIRT_BACKEND
ARG KERNEL_IMAGE

COPY machine/$MACHINE/fstab.in /etc/fstab
COPY machine/$MACHINE/fw_env.config.in /etc/fw_env.config
COPY machine/$MACHINE/interfaces.in /etc/network/interfaces
ADD machine/$MACHINE/kernel-modules-*.tar.gz /usr/lib/modules
ADD machine/$MACHINE/kernel-artifacts-*.tar.gz /boot

RUN sed -i "s/@@VIRT_BACKEND@@/${VIRT_BACKEND}/g" /etc/fstab

# install rpi firmware
RUN if [[ "$MACHINE" == "rpi3" ]]; then \
      apk add --no-cache linux-firmware-brcm; \
    fi

# install kernel and dummy initramfs to ostree location
RUN K_VER=$(ls /usr/lib/modules) && \
    cp /boot/$KERNEL_IMAGE /usr/lib/modules/$K_VER/vmlinuz && \
    touch /usr/lib/modules/$K_VER/initramfs.img && \
    rm -rf boot
