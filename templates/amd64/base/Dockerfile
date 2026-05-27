# templates/amd64/base/Dockerfile
#
# nomlib-builder:0.13.1-amd64
# syntax=docker/dockerfile:1
#

ARG VERSION="0.13.1"
ARG BASE_IMAGE="joseluisq/docker-osxcross:1.0.0-beta.2"
#ENV VERSION=${VERSION}

FROM "${BASE_IMAGE}"

# Default number of CPU cores to utilize
ARG CPU_CORES=2
ENV MAKEFLAGS="-j${CPU_CORES}"

ARG INSTALL_PREFIX=/app/vendor
ARG INSTALL_HOST=linux

LABEL version="0.13.1" \
    tag="i8degrees/nomlib-builder:0.13.1-amd64" \
    description="Docker image for cross-compiling nomlib for Linux (musl libc) & macOS (osxcross)." \
    maintainer="Jeffrey Carpenter <i8degrees@gmail.com>"

# build-essential \
RUN set -eux \
    && dpkg --add-architecture amd64 \
    && DEBIAN_FRONTEND=noninteractive apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
    autoconf \
    automake \
    bash \
    bzip2 \
    clang-tidy \
    clang-tools-19 \
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
    libtool \
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
RUN update-alternatives \
  --install /usr/bin/clang-cl clang-cl /usr/bin/clang-cl-19 50

# Cleanup 2GB of build files unused by us (osxcross) 
RUN \
    rm -rf /usr/local/osxcross/build

# Static linking for C++ code
RUN set -eux \
    # Create appropriate directories for current user
    && mkdir -p \
      /app \
      "${INSTALL_PREFIX}/${INSTALL_HOST}" \
    && true

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
ENV PKG_CONFIG_PATH=${INSTALL_PREFIX}/${INSTALL_HOST}/freetype/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig
ENV CC=/usr/bin/clang
ENV CXX=/usr/bin/clang++
# Future ARG
#ENV CC=/usr/bin/clang-cl
#ENV CXX=/usr/bin/clang-cl

ENV TARGET=amd64

# pkg-config related environment variables
ENV PKG_CONFIG_ALLOW_CROSS=1
ENV PKG_CONFIG_ALL_STATIC=1

# `coreutils` package yields `nproc`, so we take all but one of the reported
# CPU cores for building. Of course, this can always be overriden by the 
# end-user.
ARG CPU_CORES="$(($(nproc)-1))"
ENV MAKEFLAGS="-j${CPU_CORES}"

#&& /vendor/bin/freetype-config --cflags --libs --prefix --ftversion \
#&& /vendor/bin/sdl2-config --cflags --libs --prefix \
#&& ls -1 /vendor/lib \
#&& ls -1 /vendor/lib/pkgconfig \
#&& ls -1 /vendor/lib/cmake \
#&& ls -1 /vendor/share \
RUN set -eux \
    && make -v \
    && cmake --version \
    && clang --version \
    && clang++ --version \
    && clang-cl --version \
    && gcc --version \
    && g++ --version \
    && python3 --version \
    && true
RUN set -eux \
    && ls -1 /usr/local/lib \
    && ls -1 /usr/local/share \
    && ls -1 "${INSTALL_PREFIX}" \
    && ls -1 "${INSTALL_PREFIX}/${INSTALL_HOST}" \
    && true
#&& /usr/local/bin/freetype-config --cflags --libs --prefix --ftversion \
#&& /usr/local/bin/sdl2-config --cflags --libs --prefix \
#&& ls -1 /usr/local/lib/pkgconfig \
#&& ls -1 /usr/local/lib/cmake \

# Set up non-root user for development (optional but recommended)
# FIXME(JEFF): We are unable to CD to /app since it is a bind mount that otherwise
# breaks our build system if we were to COPY the source directory into the
# container instead. 
#ARG USERNAME=app
#ARG USER_UID=1000
#ARG USER_GID=$USER_UID

#RUN groupadd --gid $USER_GID $USERNAME \
    # && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    # && apt-get update \
    # && apt-get install -y sudo \
    # && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    # && chmod 0440 /etc/sudoers.d/$USERNAME \
    # && rm -rf /var/lib/apt/lists/* \
    # && chown 1000:1000 /app;

# Switch to non-root user
# USER $USERNAME
# Set up bash prompt and aliases
# RUN echo 'export PS1="\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "' >> /home/$USERNAME/.bashrc

###

WORKDIR /app

CMD ["/bin/bash"]

