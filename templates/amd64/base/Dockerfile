
ARG VERSION="0.13.1"
ARG DEBIAN_VERSION=13.4
#ENV VERSION=${VERSION}

#FROM silkeh/clang:20-bullseye
FROM debian:${DEBIAN_VERSION}

LABEL version="0.13.1" \
    tag="i8degrees/nomlib-builder:0.13.1-amd64" \
    description="Docker image for cross-compiling nomlib for Linux (musl libc) & macOS (osxcross)." \
    maintainer="Jeffrey Carpenter <i8degrees@gmail.com>"

#ARG TOOLCHAIN=0.13.1

RUN set -eux \
    && dpkg --add-architecture amd64 \
    && DEBIAN_FRONTEND=noninteractive apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
    autoconf \
    automake \
    build-essential \
    bzip2 \
    clang \
    clang-tidy \
    clang-tools-19 \
    cmake \
    curl \
    doxygen \
    file \
    git \
    git-lfs \
    graphviz \
    make \
    pandoc \
    patch \
    pkg-config \
    python3 \
    python3-pip \
    xdg-utils \
    zip \
    zstd \
    xvfb \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true
RUN update-alternatives \
  --install /usr/bin/clang-cl clang-cl /usr/bin/clang-cl-19 50

# Static linking for C++ code
RUN set -eux \
    # Create appropriate directories for current user
    && mkdir -p /app \
    && true

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:/usr/lib/pkgconfig
ENV CC=/usr/bin/clang
ENV CXX=/usr/bin/clang++

ENV TARGET=amd64

# pkg-config related environment variables
ENV PKG_CONFIG_ALLOW_CROSS=1
ENV PKG_CONFIG_ALL_STATIC=1

RUN set -eux \
    && cmake --version \
    && clang++ --version \
    && clang-cl --version \
    && true

WORKDIR /app

CMD ["bash"]

