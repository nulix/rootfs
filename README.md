# The rootfs part of the NULIX OS

## Build and export default rootfs image

```sh
docker build -o - . | gzip > nulix-rootfs-1.0.0.tar.gz
```

## Build rauc update bundle

```sh
docker build -f Dockerfile.bundle . -o .
```

## Build swupdate update bundle

```sh
docker build -f Dockerfile.ota-update . -o .
```

## Docker image build - using defaults

```sh
docker build . -t nulix-rootfs:1.0.0
```

## Docker image build - set virtualization tech

```sh
docker build . -t nulix-rootfs:1.0.0 --build-arg VIRT_TECH="lxc"
docker build . -t nulix-rootfs:1.0.0 --build-arg VIRT_TECH="docker"
docker build . -t nulix-rootfs:1.0.0 --build-arg VIRT_TECH="podman"
```

## Test rootfs docker image

```sh
docker run -it --rm nulix-rootfs:1.0.0
```
