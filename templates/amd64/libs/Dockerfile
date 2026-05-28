# nomlib-builder:0.13.1-amd64-libs
#
# syntax=docker/dockerfile:1
#

ARG VERSION=0.13.1-amd64

FROM i8degrees/nomlib-builder:${VERSION}
LABEL   version="0.13.1" \
        tag="i8degrees/nomib-builder:${VERSION}-libs" \
        description="Docker image for cross-compiling nomlib for Linux (musl libc) & macOS (osxcross)." \
        maintainer="Jeffrey Carpenter <i8degrees@gmail.com>"

# third-party dependencies for engine
ARG INSTALL_PREFIX="/app/vendor"
ARG INSTALL_HOST="linux"
ARG BUILD_TYPE=Rel

ENV INSTALL_PREFIX="${INSTALL_PREFIX}"
ENV INSTALL_HOST="${INSTALL_HOST}"
ENV BUILD_TYPE="${BUILD_TYPE}"

WORKDIR /
#FROM i8degrees/nomlib-builder:${VERSION} AS freetype
# freetype v2.14.3
ARG WORKDIR="/tmp/freetype.git"

# env
ARG VERSION="2.14.3"
ARG GIT_VERSION="VER-2-14-3"
ARG GIT_URL="https://gitlab.freedesktop.org/freetype/freetype"
# TODO: add github mirror URL

# configure
WORKDIR ${WORKDIR}
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    libharfbuzz-dev \
    libharfbuzz0b \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true
RUN git clone "${GIT_URL}" "${WORKDIR}"
RUN git checkout "${GIT_VERSION}"
# build
RUN \
  sh ./autogen.sh; \
  ./configure \
    --prefix="${INSTALL_PREFIX}/${INSTALL_HOST}/freetype" \
    --enable-freetype-config
RUN make ANSIFLAGS=""
# install
RUN make -j1 install && rm -rf ${WORKDIR}

# sdl2 v2.24.x
#FROM i8degrees/nomlib-builder:${VERSION} AS sdl2

ARG WORKDIR=/tmp/sdl2.git
# env
ARG GIT_URL="https://github.com/libsdl-org/SDL.git"
ARG GIT_TAG=release-2.24.x
# configure
WORKDIR ${WORKDIR}
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    libdecor-0-0 \
    libdrm2 \
    libgbm1 \
    libpulse0 \
    libsamplerate0 \
    libwayland-client0 \
    libwayland-cursor0 \
    libx11-6 \
    libxcursor1 \
    libxext-dev \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxkbcommon0 \
    libxrandr2 \
    libxss1 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true
RUN git clone ${GIT_URL} ${WORKDIR}
RUN git checkout ${GIT_TAG} && mkdir build

# build
WORKDIR ${WORKDIR}/build
RUN cmake \
  -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \  
  -DCMAKE_C_COMPILER=${CC} \
  -DCMAKE_CXX_COMPILER=${CXX} \
  -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX}/${INSTALL_HOST}/sdl2 \
..
#-DCMAKE_WAYLAND=on \
#-DVIDEO_KMSDRM=off \
#-DWAYLAND_SHARED=off \
# install
RUN make -j1 install && rm -rf ${WORKDIR}

# sdl2_ttf
#FROM i8degrees/nomlib-builder:${VERSION} AS sdl2-ttf

ARG WORKDIR=/tmp/sdl2_ttf.git

# env
ARG GIT_TAG=release-2.0.12
ARG GIT_URL="https://github.com/libsdl-org/SDL_ttf.git"

WORKDIR ${WORKDIR}
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    libharfbuzz-dev \
    libharfbuzz0b \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true
RUN git clone ${GIT_URL} ${WORKDIR}
RUN git checkout ${GIT_TAG}

RUN \
  cp -av "${INSTALL_PREFIX}/${INSTALL_HOST}/sdl2/share/aclocal/sdl2.m4" \
    /usr/share/aclocal/sdl2.m4;
RUN \
  ./autogen.sh && autoupdate; \
  rm -rf aclocal.m4 autom4te.cache; \
  autoreconf --force --install; \
  ./configure \
  --prefix=${INSTALL_PREFIX}/${INSTALL_HOST}/sdl2_ttf \
  --with-freetype-prefix=${INSTALL_PREFIX}/${INSTALL_HOST}/freetype \
  --with-sdl-exec-prefix=${INSTALL_PREFIX}/${INSTALL_HOST}/sdl2
RUN make
RUN make -j1 install && rm -rf ${WORKDIR}

# sdl2_image v2.0.0
#FROM i8degrees/nomlib-builder:${VERSION} AS sdl2-image

ARG WORKDIR=/tmp/sdl2_image.git

# env
ARG GIT_URL="https://github.com/libsdl-org/SDL_image.git"
ARG GIT_TAG=release-2.0.0

WORKDIR ${WORKDIR}
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    libjpeg62-turbo \
    libjpeg62-turbo-dev \
    libpng-dev \
    libpng16-16t64 \
    libtiff-dev \
    libtiff6 \
    libwebp7 \
    libwebpdemux2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true
RUN git clone ${GIT_URL} ${WORKDIR}
RUN git checkout ${GIT_TAG}
#RUN git switch -c release-2.0.0

RUN ./autogen.sh; \
    ./configure \
      --with-sdl-prefix="${INSTALL_PREFIX}/${INSTALL_HOST}/sdl2" \
      --prefix="${INSTALL_PREFIX}/${INSTALL_HOST}/sdl2_image"
RUN make
RUN make -j1 install && rm -rf ${WORKDIR}

# libRocket v1.3.0
#FROM i8degrees/nomlib-builder:${VERSION} AS librocket

# TODO: replace with RmlUI source tree
ARG WORKDIR=/tmp/libRocket.git

ARG NAME=libRocket
ARG VERSION=1.3.0
ARG GIT_URL="https://github.com/i8degrees/libRocket.git"
ARG GIT_TAG=dev

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    liblua5.1-0 \
    liblua5.1-0-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true
RUN git clone ${GIT_URL} ${WORKDIR}

WORKDIR ${WORKDIR}
RUN git checkout ${GIT_TAG} && mkdir build

WORKDIR ${WORKDIR}/build
# CXXFLAGS is used by cmake to init CMAKE_CXX_FLAGS
# CXXFLAGS=-Wno-register; cmake \
RUN cmake \
  -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -DCMAKE_CXX_STANDARD=14 \
  -DCMAKE_CXX_STANDARD_REQUIRED=on \
  -DCMAKE_C_COMPILER=${CC} \
  -DCMAKE_CXX_COMPILER=${CXX} \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}/${INSTALL_HOST}/libRocket" \
  -DBUILD_SAMPLES=off \
  -DBUILD_LUA_BINDINGS=on \
../Build
RUN make
RUN make -j1 install && rm -rf ${WORKDIR}

# Patch the cmake module location
#RUN \
  #mkdir -p "${INSTALL_PREFIX}/${INSTALL_HOST}/libRocket/lib/cmake/libRocket/"; \
  #cp -av "${INSTALL_PREFIX}/${INSTALL_HOST}/libRocket/lib/libRocket/cmake/libRocket/*" \
#"${INSTALL_PREFIX}/${INSTALL_HOST}/libRocket/lib/cmake/libRocket/"

#FROM i8degrees/nomlib-builder:${VERSION} AS libsndfile
# libsndfile

# env
ARG GIT_URL="https://github.com/libsndfile/libsndfile.git"
ARG GIT_TAG=1.0.25
ARG WORKDIR=/tmp/libsndfile.git

WORKDIR ${WORKDIR}
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    libasound2t64 \
    libflac-dev \
    libmp3lame-dev \
    libmpg123-dev \
    libogg-dev \
    libopus-dev \
    libvorbis-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true
RUN git clone "${GIT_URL}" ${WORKDIR}
RUN git switch -c $GIT_TAG && mkdir build

WORKDIR ${WORKDIR}/build
RUN cmake \
  -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -DCMAKE_C_COMPILER=${CC} \
  -DCMAKE_CXX_COMPILER=${CXX} \
  -DBUILD_SHARED_LIBS=1 \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}/${INSTALL_HOST}/libsndfile" \
  -DBUILD_EXAMPLES=off \
  -DBUILD_PROGRAMS=off \
..
RUN make
RUN make -j1 install && rm -rf ${WORKDIR}

# openal v1.17.2
#FROM i8degrees/nomlib-builder:${VERSION} AS openal

# env
#ARG GIT_TAG=1.25.2
ARG GIT_TAG=openal-soft-1.17.2
ARG GIT_URL=https://github.com/kcat/openal-soft
ARG WORKDIR=/tmp/openal.git

# TODO(JEFF): Add libpipewire-0.3.0-dev and
# libpipewire-0.3.0 for OpenAL support.
# TODO(JEFF): Tell OpenAL where libsndfile is located so it
# is capable of loading audio formats beyond WAVE.
WORKDIR ${WORKDIR}
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    libasound2-dev \
    libasound2t64 \
    libpulse-dev \
    libpulse0 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true
RUN git clone "${GIT_URL}" ${WORKDIR}
#RUN git checkout ${GIT_TAG} && mkdir build
RUN git switch -c ${GIT_TAG}

WORKDIR ${WORKDIR}/build
RUN cmake \
  -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -DCMAKE_C_COMPILER=${CC} \
  -DCMAKE_CXX_COMPILER=${CXX} \
  -DBUILD_SHARED_LIBS=1 \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}/${INSTALL_HOST}/openal" \
..
RUN make
RUN make -j1 install && rm -rf ${WORKDIR}

# gtest
#FROM i8degrees/nomlib-builder:${VERSION} AS gtest

ARG WORKDIR=/tmp/gtest.git

# env
ARG GIT_TAG=v1.8.x
ARG GIT_URL="https://github.com/google/googletest"
ARG WORKDIR=/tmp/gtest.git

WORKDIR ${WORKDIR}
RUN git clone ${GIT_URL} ${WORKDIR}
RUN git checkout ${GIT_TAG} && mkdir build

WORKDIR ${WORKDIR}/build

# FIXME(JEFF): We must use G++ to build GTest, otherwise we receive errors when 
# linking to the static gtest library, i.e.: 
#
# /usr/bin/ld: /app/vendor/linux/gtest/lib/libgtest.a(gtest-all.cc.o): warning: relocation against `_ZTVN7testing8internal17StreamingListenerE' in read-only section `.text._ZN7testing8internal17StreamingListenerD2Ev[_ZN7testing8internal17StreamingListenerD2Ev]'
# /usr/bin/ld: /app/vendor/linux/gtest/lib/libgtest.a(gtest-all.cc.o): relocation R_X86_64_PC32 against symbol `_ZN7testing8UnitTestD1Ev' can not be used when making a shared object; recompile with -fPIC
# NOTE(JEFF): This removes `-Werror=maybe-uninitialized` from the default compile 
# flags that are set from internal_utils.cmake at line 105.

# IMPORTANT(JEFF): `-DBUILD_SHARED_LIBS=0` so we can generate a static 
# library for gtest, i.e.: libgtest.a
#-DCMAKE_C_COMPILER=/usr/bin/gcc \
#-DCMAKE_CXX_COMPILER=/usr/bin/g++ \
RUN \
  cmake \
  -DBUILD_GMOCK=off \
  -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
  -DCMAKE_CXX_FLAGS="-Wall -Wshadow -Wno-maybe-uninitialized -fPIC" \
  -DCMAKE_C_COMPILER=${CC} \
  -DCMAKE_CXX_COMPILER=${CXX} \
  -DBUILD_SHARED_LIBS=0 \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}/${INSTALL_HOST}/gtest" \
..
RUN make
RUN make -j1 install && rm -rf ${WORKDIR}

# jsoncpp
#FROM i8degrees/nomlib-builder:${VERSION} AS jsoncpp
ARG WORKDIR=/tmp/jsoncpp.git
#RUN [ -d "${WORKDIR}" ] && rm "${WORKDIR}" && mkdir "${WORKDIR}"

# env
ARG GIT_URL="https://github.com/open-source-parsers/jsoncpp.git"
ARG GIT_TAG=v0.7.0

WORKDIR ${WORKDIR}
RUN git clone ${GIT_URL} ${WORKDIR}
RUN mkdir -p dist build

# NOTE(JEFF): build compatible with svn-release-0.6.0-rc2 branch, but not binary 
# compat as per tag release
RUN git switch -c ${GIT_TAG}

WORKDIR ${WORKDIR}
RUN python3 amalgamate.py

# FIXME(JEFF): We should not have to patch the location of the header files 
# below!
RUN \
  mkdir -p "${INSTALL_PREFIX}/jsoncpp" && \
  cp -av /tmp/jsoncpp.git/dist/* "${INSTALL_PREFIX}/jsoncpp" && \
  rm -rf ${WORKDIR};
RUN \
  cd "${INSTALL_PREFIX}/jsoncpp"; \
  ln -sf ./json/json.h ./json.h && \
  ln -sf ./json/json-forwards.h ./json-forwards.h;

# rapidxml v1.13 by discord
#FROM i8degrees/nomlib-builder:${VERSION} AS rapidxml

ARG WORKDIR=/tmp/rapidxml.git
#RUN [ -d "${WORKDIR}" ] && rm "${WORKDIR}" && mkdir "${WORKDIR}"
# env
ARG GIT_TAG=master
ARG GIT_URL="https://github.com/discord/rapidxml"

WORKDIR ${WORKDIR}
RUN git clone ${GIT_URL} ${WORKDIR}
RUN git checkout master

# https://sourceforge.net/p/rapidxml/bugs/16/
COPY \
  ./patches/rapidxml_bug16.patch ${WORKDIR}/rapidxml_bug16.patch
RUN git apply "${WORKDIR}/rapidxml_bug16.patch"

WORKDIR ${WORKDIR}
RUN \
  mkdir -p "${INSTALL_PREFIX}/rapidxml" && \
  cp -av /tmp/rapidxml.git/* "${INSTALL_PREFIX}/rapidxml" && \
  rm -rf ${WORKDIR};

# tclap v1.x
#FROM i8degrees/nomlib-builder:${VERSION} AS tclap
ARG WORKDIR=/tmp/tclap.git

# env
# TODO: github mirror
ARG GIT_URL="https://git.code.sf.net/p/tclap/code"
ARG GIT_TAG=12cee38782897cfe60a1611615c200c45cd99eaf

WORKDIR ${WORKDIR}
RUN git clone ${GIT_URL} ${WORKDIR}
#RUN git switch -c ${GIT_TAG}
RUN git checkout ${GIT_TAG}

#COPY \
  #configure.patch /tmp/tclap.git/configure.patch
# do not build docs, examples or tests
#RUN git apply configure.patch
RUN \
   mv configure.in configure.ac || true; \
  ./autotools.sh; \
  ./autoupdate; \
  ./configure \
    --prefix="${INSTALL_PREFIX}/tclap"
RUN make
RUN make -j1 install \
  && rm -rf ${WORKDIR} && true

ARG GIT_TAG="master"
ARG GIT_URL="https://github.com/mikke89/RmlUI"
ARG WORKDIR="/tmp/rmlui"

WORKDIR "${WORKDIR}"
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    autoconf \
    autogen \
    automake \
    bzip2 \
    cmake \
    curl \
    file \
    git \
    libc6 \
    libfreetype-dev \
    libfreetype6 \
    liblua5.1-0 \
    liblua5.1-0-dev \
    libtool \
    make \
    pandoc \
    patch \
    pkg-config \
    xdg-utils \
    zip \
    zstd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true
RUN git clone "${GIT_URL}" "${WORKDIR}" && \
  git chekout "${GIT_TAG}" && mkdir build

WORKDIR /tmp/rmlui/build
RUN \
  clang++ --version >> clang.version; \
  cmake --version >> cmake.version;
RUN cmake \
  -DCMAKE_INSTALL_PREFIX="${INSTALL_PREFIX}/${INSTALL_HOST}/rmlui" \
  -DBUILD_SAMPLES=off \
  -DBUILD_LUA_BINDINGS=on \
  -DCMAKE_BUILD_TYPE="${BUILD_TYPE}" \
  -DROCKET_DEBUG=on \
  -DCMAKE_VERBOSE_MAKEFILE=1 ../Build
RUN make
#RUN make -j1 install

CMD ["/bin/bash"]

