# templates/amd64/macos/Dockerfile
#
# nomlib-builder:0.13.1-amd64-macos
# syntax=docker/dockerfile:1
#

ARG VERSION="0.13.1"
ARG BASE_IMAGE="joseluisq/docker-osxcross:1.0.0-beta.2"
FROM "${BASE_IMAGE}"

ARG VERSION="0.13.1"
ARG BASE_IMAGE="joseluisq/docker-osxcross:1.0.0-beta.2"

LABEL version="${VERSION}" \
    tag="i8degrees/nomlib-builder:${VERSION}-amd64-macos" \
    description="Docker image for cross-compiling nomlib on 64-bit Linux to macOS (osxcross)." \
    maintainer="Jeffrey Carpenter <i8degrees@gmail.com>"

# Default number of CPU cores to utilize
ARG CPU_CORES=2

ARG INSTALL_PREFIX=/app/vendor
ARG INSTALL_HOST=macos

ENV MAKEFLAGS="-j${CPU_CORES}"
ENV VERSION="${VERSION}"
ENV INSTALL_PREFIX="${INSTALL_PREFIX}"
ENV INSTALL_HOST="${INSTALL_HOST}"


# build-essential \
RUN set -eux \
    && dpkg --add-architecture amd64 \
    && DEBIAN_FRONTEND=noninteractive apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
    autoconf \
    automake \
    bash \
    bzip2 \
    cmake \
    coreutils \
    curl \
    doxygen \
    file \
    git \
    git-lfs \
    graphviz \
    less \
    libc6 \
    libflac14 \
    libmpg123-0t64 \
    libopus0 \
    libtool \
    libvorbis0a \
    libvorbisenc2 \
    make \
    mesa-common-dev \
    pandoc \
    patch \
    pkg-config \
    python3 \
    python3-pip \
    rsync \
    xauth \
    xdg-utils \
    xvfb \
    zip \
    zlib1g-dev \
    zstd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true

# Cleanup 2GB of build files unused by us (osxcross) 
RUN \
    rm -rf /usr/local/osxcross/build

ENV PATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH"
ENV PKG_CONFIG_PATH="${INSTALL_PREFIX}/${INSTALL_HOST}/freetype/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig"
ENV CC="x86_64-apple-darwin22.4-clang"
ENV CXX="x86_64-apple-darwin22.4-clang++"
ENV MACOSX_DEPLOYMENT_TARGET="10.9"

ENV OSXCROSS_TARGET_DIR="/usr/local/osxcross/target"
ENV OSXCROSS_SDK="${OSXCROSS_TARGET_DIR}/SDK/MacOSX13.3.sdk"
ENV OSXCROSS_TARGET="x86_64"
ENV OSXCROSS_HOST="${OSXCROSS_TARGET}-apple-darwin22.4"
ENV OSXCROSS_VERSION_MIN="${MACOSX_DEPLOYMENT_TARGET}"
ENV MACPORTS_PREFIX="${OSXCROSS_TARGET}/macports/pkgs/opt/local"
# Target CPU env (arch)
ENV TARGET="${OSXCROSS_TARGET}"

# pkg-config related environment variables
ENV PKG_CONFIG_ALLOW_CROSS=1
ENV PKG_CONFIG_ALL_STATIC=1

# `coreutils` package yields `nproc`, so we take all but one of the reported
# CPU cores for building. Of course, this can always be overriden by the 
# end-user.
ARG CPU_CORES="$(($(nproc)-1))"
ENV MAKEFLAGS="-j${CPU_CORES}"

WORKDIR /app

CMD ["/bin/bash"]

