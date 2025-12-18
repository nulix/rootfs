ARG SSH_PUBLIC_KEY

# install openssh
RUN apk add --no-cache openssh

# enable the service
RUN rc-update add sshd default

# install custom public key and disable password authentication
RUN if [ -n "${SSH_PUBLIC_KEY}" ]; then \
      mkdir -p ${HOME}/.ssh; \
      echo "${SSH_PUBLIC_KEY}" > ${HOME}/.ssh/authorized_keys; \
      chmod 600 ${HOME}/.ssh/authorized_keys; \
      sed -i "s/^#PasswordAuthentication yes/PasswordAuthentication no/" \
        /etc/ssh/sshd_config; \
    fi
