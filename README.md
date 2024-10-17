# rootfs

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

## Docker image build - set virtualization backend

```sh
docker build . -t nulix-rootfs:1.0.0 --build-arg NULIX_VIRT_BACKEND="lxc"
docker build . -t nulix-rootfs:1.0.0 --build-arg NULIX_VIRT_BACKEND="docker"
docker build . -t nulix-rootfs:1.0.0 --build-arg NULIX_VIRT_BACKEND="podman"
```

## Test rootfs docker image

```sh
docker run -it --rm nulix-rootfs:1.0.0
```

