# syntax = devthefuture/dockerfile-x

ARG MACHINE
ARG ARCH
ARG ALPINE_VERSION
ARG HOSTNAME
ARG KERNEL_IMAGE
ARG VIRT_BACKEND
ARG SERIAL_PORT
ARG SERIAL_BAUD
ARG UPD8_KEYS_FILE
ARG UPD8_MACHINE_REG_TKN_FILE
ARG DISTRO_VERSION_MAJOR
ARG DISTRO_VERSION_MINOR
ARG DISTRO_VERSION_PATCH

INCLUDE ./Dockerfile.alpine
INCLUDE ./Dockerfile.apps
INCLUDE ./Dockerfile.upd8
INCLUDE ./Dockerfile.machine
INCLUDE ./Dockerfile.lxc
INCLUDE ./Dockerfile.docker
INCLUDE ./Dockerfile.podman
INCLUDE ./Dockerfile.openrc
INCLUDE ./Dockerfile.ostree-initramfs
INCLUDE ./Dockerfile.ostree
