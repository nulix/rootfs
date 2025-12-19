ARG SSL_CERT

# install custom certificate
RUN if [ -n "${SSL_CERT}" ]; then \
    apk add --no-cache ca-certificates; \
    echo "${SSL_CERT}" > /etc/ssl/certs/cert.crt; \
    update-ca-certificates; \
    fi
