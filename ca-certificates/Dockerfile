ARG SSL_CERT

# install custom certificate
RUN if [ -n "${SSL_CERT}" ]; then \
    apk add --no-cache ca-certificates; \
    echo "${SSL_CERT}" > /usr/share/ca-certificates/cert.pem; \
    update-ca-certificates; \
    fi
