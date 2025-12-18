###
### INSPIRED WITH:
###
# https://github.com/uptane/meta-updater/blob/master/classes/sota.bbclass
# https://github.com/uptane/meta-updater/blob/master/classes/image_types_ostree.bbclass

###
### HOW TO USE THIS FILE:
###
# docker build -f Dockerfile.ostree_repo . -o .

###
### STAGE 1 - build
###
FROM alpine AS build

ARG MACHINE
ARG DISTRO_VERSION_MAJOR
ARG DISTRO_VERSION_MINOR
ARG DISTRO_VERSION_PATCH
ARG OSTREE_REPO
ARG OSTREE_MANIFEST
ARG OSTREE_BRANCHNAME="$DISTRO_VERSION_MAJOR/stable/$MACHINE"

ARG OSTREE_ROOTFS
ARG OSTREE_UPDATE_SUMMARY
ARG OSTREE_COMMIT_SUBJECT="NULIX OS"
ARG OSTREE_COMMIT_VERSION="$DISTRO_VERSION_MAJOR.$DISTRO_VERSION_MINOR.$DISTRO_VERSION_PATCH"
ARG OSTREE_COMMIT_BODY="NULIX OS ${OSTREE_COMMIT_VERSION}"

# install build deps
RUN apk add --no-cache ostree tar

# configure rootfs
COPY ${OSTREE_ROOTFS}-*.tar.gz /${OSTREE_ROOTFS}.tar.gz
RUN mkdir ${OSTREE_ROOTFS} && \
    tar --xattrs --xattrs-include=* -xzf ${OSTREE_ROOTFS}.tar.gz -C ${OSTREE_ROOTFS}
# [workaround]:
# > [2/2] RUN mv /etc /usr:
# 1.915 mv: can't remove '/etc/resolv.conf': Device or resource busy
# 1.915 mv: can't remove '/etc/hosts': Device or resource busy
RUN rm -rf ${OSTREE_ROOTFS}/etc

# reuse existing repo if possible
COPY ${OSTREE_REPO}* /${OSTREE_REPO}

# init empty repo if needed
RUN if ! ostree --repo=${OSTREE_REPO} refs 2>&1 > /dev/null; then \
      echo "creating new ostree repo..."; \
      ostree --repo=${OSTREE_REPO} init --mode=archive-z2; \
    else \
      echo "reusing existing ostree repo with the following branches:"; \
      ostree --repo=${OSTREE_REPO} refs; \
    fi

# commit the result
RUN ostree_target_hash=$(ostree --repo=${OSTREE_REPO} commit \
           --tree=dir=${OSTREE_ROOTFS} \
           --skip-if-unchanged \
           --branch=${OSTREE_BRANCHNAME} \
           --subject="${OSTREE_COMMIT_SUBJECT}" \
           --body="${OSTREE_COMMIT_BODY}" \
           --add-metadata-string=version="${OSTREE_COMMIT_VERSION}" \
           ${EXTRA_OSTREE_COMMIT}) && \
    echo $ostree_target_hash > ${OSTREE_MANIFEST}

RUN if [ "${OSTREE_UPDATE_SUMMARY}" = "1" ]; then \
        ostree --repo=${OSTREE_REPO} summary -u; \
    fi

# compress ostree repo
RUN tar czf ${OSTREE_REPO}.tar.gz ${OSTREE_REPO}

###
### STAGE 2 - export build artifacts
###
FROM scratch

ARG OSTREE_REPO
ARG OSTREE_MANIFEST

# copy build artifacts
COPY --from=build ${OSTREE_REPO} ${OSTREE_REPO}
COPY --from=build ${OSTREE_REPO}.tar.gz ${OSTREE_REPO}.tar.gz
COPY --from=build ${OSTREE_MANIFEST} ${OSTREE_MANIFEST}
