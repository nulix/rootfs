RUN mkdir -p /usr/apps

COPY apps/apps/docker-compose.yml* /usr/apps
COPY apps/files/$VIRT_BACKEND-apps.initd /etc/init.d/apps
COPY apps/files/app.sh /usr/bin/app

# enable the service
RUN rc-update add apps boot
