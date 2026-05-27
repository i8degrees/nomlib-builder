# syntax=docker/dockerfile:1

FROM debian:13-slim AS windows

# Default number of CPU cores to utilize
ARG CPU_CORES=2
ENV MAKEFLAGS="-j${CPU_CORES}"

ARG INSTALL_PREFIX=/app/vendor
ARG INSTALL_HOST=windows

WORKDIR /tmp
RUN set -eux \
    && dpkg --add-architecture amd64 \
    && DEBIAN_FRONTEND=noninteractive apt-get update -qq \
    && DEBIAN_FRONTEND=noninteractive apt-get install -qq -y --no-install-recommends --no-install-suggests \
    autoconf \
    automake \
    bash \
    bzip2 \
    ca-certificates \
    clang-tidy \
    clang-tools-19 \
    cmake \
    curl \
    file \
    git \
    git-lfs \
    less \
    make \
    msitools \
    patch \
    python3-minimal \
    rsync \
    zip \
    zstd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true
RUN update-alternatives \
  --install /usr/bin/clang-cl clang-cl /usr/bin/clang-cl-19 50

# Static linking for C++ code
RUN set -eux \
    # Create appropriate directories for current user
    && mkdir -p \
    /app \
    "${INSTALL_PREFIX}/${INSTALL_HOST}" \
    && true

ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:$PATH
ENV PKG_CONFIG_PATH=${INSTALL_PREFIX}/${INSTALL_HOST}/freetype/lib/pkgconfig:/usr/local/lib/pkgconfig:/usr/lib/pkgconfig
ENV CC=/usr/bin/clang-cl
ENV CXX=/usr/bin/clang-cl

ENV TARGET=amd64

# pkg-config related environment variables
ENV PKG_CONFIG_ALLOW_CROSS=1
ENV PKG_CONFIG_ALL_STATIC=1

# `coreutils` package yields `nproc`, so we take all but one of the reported
# CPU cores for building. Of course, this can always be overriden by the 
# end-user.
ARG CPU_CORES="$(($(nproc)-1))"
ENV MAKEFLAGS="-j${CPU_CORES}"

RUN set -eux \
    && make -v \
    && cmake --version \
    && clang-cl --version \
    && python3 --version \
    && msiextract --version \
    && true

# Install MS Windows SDK 11 and MSVC 2017 v15.8 tools
#
# MSVC 14.50 (Visual Studio 2017 v15.8) -- https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170
# Targeting x64,x86,arm64 platforms
# ...from a x64 host
#
# (The arm target platform is not available for the parameters specified below)

ARG HOST_CPU=x64
# TODO(JEFF): We will add arm64 at a later point in the future, once we have 
# satisfied 64-bit and 32-bit builds done.
#ARG TARGET_CPU=x64,x86,arm64
ARG TARGET_CPU=x64,x86

# Windows 11 SDK 11.0.26100.x
#ARG SDK_VERS=26100
# MSVC 14.50 (Visual Studio 2017 v15.8) -- https://learn.microsoft.com/en-us/cpp/windows/latest-supported-vc-redist?view=msvc-170
#ARG MSVC_VERS=14.50

# Windows 10 SDK 10.0.19041.0
ARG SDK_VERS=19041
ARG VS_VERS=2022

#ENV SCRIPT_URL="https://gist.githubusercontent.com/mmozeiko/7f3162ec2988e81e56d5c4e22cde9977/raw/ba48b0a3d9ea05c6caa5e583eda60fa7510da4bc/portable-msvc.py"
# This is a fork of the original gist that lets us obtain the SDK files 
# necessary to cross-compile Windows binaries using clang-cl.
ENV GIT_URL="https://gist.github.com/i8degrees/5fcbf25b3a85181775ccace12706b3a5"
ENV WORKDIR=/tmp/portable-msvc

RUN git clone ${GIT_URL} ${WORKDIR}
#RUN git checkout ${GIT_TAG}
WORKDIR ${WORKDIR}
RUN \
  python3 ./portable-msvc.py --accept-license \
  --sdk-version ${SDK_VERS} \
  --vs ${VS_VERS} \
  --host ${HOST_CPU} \
  --target ${TARGET_CPU}

FROM windows AS install_sdk

#ARG INSTALL_PREFIX=/app/vendor
#ARG INSTALL_HOST=windows

RUN mkdir -p ${INSTALL_PREFIX}/${INSTALL_HOST}/msvc
RUN rsync -av ./msvc/ ${INSTALL_PREFIX}/${INSTALL_HOST}/msvc
  #&& true
#&& rm -rf ./downloads \
#cmake --preset debug-clang-cl

WORKDIR /app

CMD ["/bin/bash"]
