# syntax = devthefuture/dockerfile-x
###
### STAGE 1 - BUILD
###
FROM alpine:edge AS build

# needed if building rust app with alpine
ENV RUSTFLAGS='-Ctarget-feature=-crt-static'

# install build deps
RUN apk add --no-cache git rust cargo musl-dev pkgconfig ostree-dev

# upd8 repo and revision
ARG UPD8_REPO="https://github.com/nulix/upd8.git"
ARG UPD8_SRC_REV="2da397fd4ac436b8e4765558289f3c2c5b705688"

# build upd8
RUN git clone $UPD8_REPO && \
    cd upd8 && \
    git checkout $UPD8_SRC_REV
RUN cd upd8 && \
    cargo build --release

###
### STAGE 2 - RUNTIME
###
FROM ../alpine/Dockerfile

ARG UPD8_KEYS_FILE
ARG UPD8_MACHINE_REG_TKN_FILE
ARG UPD8_API_URL
ARG MACHINE

# install runtime deps
RUN apk add --no-cache libgcc

# install upd8
COPY --from=build /upd8/target/release/upd8 /usr/bin
COPY --from=build /upd8/config.example.yml /etc/upd8/config.yml

# set config
RUN sed -i "s|api_url: \"https://api.nulix.io\"|api_url: \"${UPD8_API_URL}\"|" /etc/upd8/config.yml
RUN sed -i "s|branch: \"1/stable/rpi3\"|branch: \"1/stable/${MACHINE}\"|" /etc/upd8/config.yml

# deploy upd8 user files
COPY upd8/${UPD8_KEYS_FILE}* /var/local/upd8/
COPY upd8/${UPD8_MACHINE_REG_TKN_FILE}* /var/local/upd8/

# install service files
COPY upd8/files/upd8.initd /etc/init.d/upd8
COPY upd8/files/upd8.confd /etc/conf.d/upd8

# enable the service
RUN rc-update add upd8 default
