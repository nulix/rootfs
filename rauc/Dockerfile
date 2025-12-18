###
### STAGE 1 - BUILD
###
FROM ./Dockerfile.alpine AS build

# install build deps
RUN apk add --no-cache git build-base cmake dbus-dev libnl3-dev glib-dev meson \
    curl-dev json-glib-dev

# rauc
RUN git clone https://github.com/rauc/rauc.git
RUN cd rauc && \
    meson setup build -Dtests=false && \
    meson compile -C build

# rauc-hawkbit-updater
RUN git clone https://github.com/rauc/rauc-hawkbit-updater.git
RUN cd rauc-hawkbit-updater && \
    meson setup build && \
    ninja -C build

###
### STAGE 2 - RUNTIME
###
FROM ./Dockerfile.alpine

ARG MACHINE

# install runtime deps
RUN apk add --no-cache libcurl libnl3 json-glib glib libfdisk dbus \
    u-boot-tools e2fsprogs

# install rauc
COPY rauc/$MACHINE/ca.cert.pem /etc/rauc/
COPY rauc/$MACHINE/system.conf-recovery.in /etc/rauc/system.conf
COPY rauc/modules.conf /lib/modules-load.d/rauc.conf
COPY --from=build /rauc/build/rauc /usr/bin
COPY --from=build /rauc/build/data/de.pengutronix.rauc.service /usr/share/dbus-1/system-services
COPY --from=build /rauc/build/data/de.pengutronix.rauc.conf /usr/share/dbus-1/system.d

# install rauc-hawkbit-updater
COPY rauc/hawkbit-updater/config.conf.in /etc/rauc-hawkbit-updater/config.conf
COPY --from=build /rauc-hawkbit-updater/build/rauc-hawkbit-updater /usr/bin
