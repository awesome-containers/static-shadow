# https://github.com/awesome-containers/static-bash
ARG STATIC_BASH_VERSION=5.2.15
ARG STATIC_BASH_IMAGE=ghcr.io/awesome-containers/static-bash

# https://github.com/awesome-containers/alpine-build-essential
ARG BUILD_ESSENTIAL_VERSION=3.17
ARG BUILD_ESSENTIAL_IMAGE=ghcr.io/awesome-containers/alpine-build-essential


FROM $STATIC_BASH_IMAGE:$STATIC_BASH_VERSION AS static-bash
FROM $BUILD_ESSENTIAL_IMAGE:$BUILD_ESSENTIAL_VERSION AS build

# hadolint ignore=DL3018
RUN apk add --no-cache acl-dev acl-static attr-dev attr-static clang

# https://github.com/shadow-maint/shadow
ARG SHADOW_VERSION=4.13

WORKDIR /src/shadow
RUN set -xeu; \
    curl -#Lo shadow.tar.gz \
        "https://github.com/shadow-maint/shadow/releases/download/$SHADOW_VERSION/shadow-$SHADOW_VERSION.tar.gz"; \
    tar -xvf shadow.tar.gz --strip-components=1; \
    rm -f shadow.tar.gz

ARG CC=clang
ARG CFLAGS='-w -g -Os -static'
ARG LDFLAGS="-static -all-static"
ARG PKG_CONFIG="pkg-config --static"
RUN set -xeu; \
    ./configure --prefix="$(pwd)/dist"\
        --disable-subordinate-ids --disable-nls \
        --without-libpam --without-audit --without-selinux --without-btrfs \
        --with-acl --with-attr ; \
    make -j"$(nproc)" install; \
    cp -v dist/sbin/* dist/bin/

WORKDIR /src/shadow/dist/etc
RUN set -xeu; \
    printf '%s\n' 'root:x:0:0:root:/:/bin/bash' \
        'nobody:x:65534:65534:nobody:/:/bin/false' > passwd; \
    printf '%s\n' 'nogroup:x:65534:' 'root:x:0:' > group; \
    sed -e 's/^MAIL_DIR/#MAIL_DIR/' -e 's/^#MAIL_FILE/MAIL_FILE/' -i login.defs

WORKDIR /src/shadow/dist/bin
RUN set -xeu; \
    rm sg vigr; \
    strip -s -R .comment --strip-unneeded ./*; \
    chown -cR 0:0 ./*; \
    ! ldd useradd && :; \
    ./useradd --help; \
    ln -sf newgrp sg; \
    ln -sf vipw vigr


# static shadow image
FROM static-bash
COPY --from=build /src/shadow/dist/etc/ /etc/
COPY --from=build /src/shadow/dist/bin/ /bin/
