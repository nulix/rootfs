ARG VIRT_TECH

# TODO: use "pass" tool for credential storing?
# https://github.com/docker/docker-credential-helpers
# https://docs.docker.com/reference/cli/docker/login/#credentials-store
RUN if [[ "$VIRT_TECH" == "docker" ]]; then \
      mkdir /var/lib/docker; \
      apk add --no-cache docker-engine docker-cli docker-openrc; \
      apk add --no-cache docker-compose; \
    elif [[ "$VIRT_TECH" == "lxc" ]]; then \
      apk add --no-cache lxc lxc-openrc; \
    elif [[ "$VIRT_TECH" == "podman" ]]; then \
      apk add --no-cache podman podman-openrc; \
    fi
