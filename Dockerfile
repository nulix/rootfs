# syntax = edrevo/dockerfile-plus

# defaults - change using --build-arg MACHINE="rpi"
ARG MACHINE="rpi"
ARG NULIX_VIRT_BACKEND="docker"

INCLUDE+ Dockerfile.alpine
INCLUDE+ Dockerfile.machine
INCLUDE+ Dockerfile.lxc
INCLUDE+ Dockerfile.docker
INCLUDE+ Dockerfile.podman
INCLUDE+ Dockerfile.openrc
INCLUDE+ Dockerfile.apps
INCLUDE+ Dockerfile.ostree-initramfs
INCLUDE+ Dockerfile.ostree

