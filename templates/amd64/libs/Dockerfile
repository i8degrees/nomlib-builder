# nomlib-builder:0.13.1-amd64-libs
#

ARG VERSION=0.13.1-amd64
ARG VERSION_TAG=0.13.1-amd64-libs

FROM i8degrees/nomlib-builder:${VERSION}
LABEL   version="0.13.1" \
        tag="i8degrees/nomlib-builder:${VERSION_TAG}" \
        description="Docker image for cross-compiling nomlib for Linux (musl libc) & macOS (osxcross)." \
        maintainer="Jeffrey Carpenter <i8degrees@gmail.com>"

#ARG INSTALL_PREFIX=/usr
ARG INSTALL_PREFIX=/tmp/vendor/linux/sdl2
ARG BUILD_TYPE=Rel
ARG SDL2_VERSION=2.24.x
ARG SDL2_TTF_VERSION=2.0.12
#ARG FREETYPE_VERSION=
ARG SDL2_IMAGE_VERSION=2.0.0
#ARG LIBROCKET_VERSION=1.3.0

ARG VERSION_TAG=0.13.1-amd64-libs
ENV LIBZ_SYS_STATIC=1

# sdl2

WORKDIR /
WORKDIR /tmp/sdl2.git
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    autoconf \
    autogen \
    automake \
    build-essential \
    bzip2 \
    cmake \
    curl \
    doxygen \
    file \
    git \
    git-lfs \
    graphviz \
    libasound2t64 \
    libc6 \
    libdecor-0-0 \
    libdrm2 \
    libegl-dev \
    libfreetype-dev \
    libfreetype6 \
    libgbm1 \
    libgl-dev \
    libgles-dev \
    libglu1-mesa-dev \
    libpulse0 \
    libsamplerate0 \
    libwayland-client0 \
    libwayland-cursor0 \
    libwayland-egl1 \
    libx11-6 \
    libxcursor1 \
    libxext6 \
    libxext-dev \
    libxfixes3 \
    libxi6 \
    libxkbcommon0 \
    libxrandr2 \
    libxss1 \
    make \
    mesa-common-dev \
    patch \
    pkg-config \
    python3 \
    python3-pip \
    xdg-utils \
    xdg-utils \
    zip \
    zstd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true
RUN git clone \
  "https://github.com/libsdl-org/SDL.git" /tmp/sdl2.git

# FIXME
#RUN git checkout release-"${SDL2_VERSION}"
RUN git checkout release-2.24.x && mkdir build

WORKDIR /tmp/sdl2.git/build
#-DCMAKE_INSTALL_PREFIX=/tmp/vendor/linux/sdl2 \
RUN cmake \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DCMAKE_INSTALL_PREFIX=/usr \
..
#-DCMAKE_WAYLAND=on \
#-DVIDEO_KMSDRM=off \
#-DWAYLAND_SHARED=off \
#..
RUN make
RUN make -j1 install
# FIXME
RUN cmake -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} ..
RUN make
RUN make -j1 install

# sdl2_ttf

WORKDIR /tmp/sdl2_ttf.git
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    autoconf \
    autogen \
    automake \
    build-essential \
    bzip2 \
    cmake \
    curl \
    file \
    git \
    git-lfs \
    libc6 \
    libfreetype-dev \
    libfreetype6 \
    libharfbuzz-dev \
    libharfbuzz0b \
    libtool \
    make \
    pandoc \
    patch \
    pkg-config \
    python3 \
    python3-pip \
    xdg-utils \
    zip \
    zstd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true
RUN git clone \
  "https://github.com/libsdl-org/SDL_ttf.git" /tmp/sdl2_ttf.git
RUN git checkout release-${SDL2_TTF_VERSION}

RUN \
  clang++ --version >> clang.version; \
  cmake --version >> cmake.version;

# FIXME(JEFF): --with-sdl-prefix= needs to be updated to /usr
RUN mkdir -p "/tmp/vendor/linux/freetype/bin" "/tmp/vendor/linux/freetype/lib/pkgconfig"

# FIXME(JEFF): WTF? Why did this suddenly break on me?
RUN [ ! -f "/tmp/vendor/linux/freetype/bin/freetype-config" ] && curl -Lv --output /tmp/vendor/linux/freetype/bin/freetype-config "https://nomlib.479831.xyz/frs/linux/freetype/bin/freetype-config"
RUN [ ! -f "/tmp/vendor/linux/freetype/lib/pkgconfig/freetype2.pc" ] && curl -Lv --output /tmp/vendor/linux/freetype/lib/pkgconfig/freetype2.pc "https://nomlib.479831.xyz/frs/linux/freetype/lib/pkgconfig/freetype2.pc"
RUN chmod +x "/tmp/vendor/linux/freetype/bin/freetype-config"

#--with-sdl-prefix=/tmp/vendor/linux/sdl2 \
RUN ./autogen.sh && autoupdate; \
  rm -rf aclocal.m4 autom4te.cache; \
  autoreconf --force --install; \
  ./configure \
  --prefix=/tmp/vendor/linux/sdl2_ttf \
  --with-freetype-prefix=/tmp/vendor/linux/freetype
RUN make
RUN make -j1 install

# sdl2_image

WORKDIR /tmp/sdl2_image.git
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    autoconf \
    autogen \
    automake \
    build-essential \
    bzip2 \
    cmake \
    curl \
    file \
    git \
    git-lfs \
    libc6 \
    libjpeg62-turbo \
    libjpeg62-turbo-dev \
    libpng16-16t64 \
    libpng-dev \
    libtiff6 \
    libtiff-dev \
    libwebp7 \
    libwebpdemux2 \
    make \
    pandoc \
    patch \
    pkg-config \
    python3 \
    python3-pip \
    xdg-utils \
    zip \
    zstd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true
RUN git clone \
  "https://github.com/libsdl-org/SDL_image.git" /tmp/sdl2_image.git
#RUN git checkout release-${SDL2_IMAGE_VERSION}
RUN git checkout release-2.0.0
#RUN git switch -c release-2.0.0

RUN \
  clang++ --version >> clang.version; \
  cmake --version >> cmake.version;

RUN ls -lhas /tmp/sdl2_image.git
RUN CC=/usr/bin/clang CXX=/usr/bin/clang++
RUN ./autogen.sh; \
    ./configure \
      --with-sdl-prefix=/tmp/vendor/linux/sdl2 \
      --prefix=/tmp/vendor/linux/sdl2_image
RUN make
RUN make -j1 install

# libRocket

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    autoconf \
    autogen \
    automake \
    build-essential \
    bzip2 \
    cmake \
    curl \
    file \
    git \
    git-lfs \
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
    python3 \
    python3-pip \
    xdg-utils \
    zip \
    zstd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true
RUN git clone \
  "https://github.com/i8degrees/libRocket.git" /tmp/librocket.git

WORKDIR /tmp/librocket.git
RUN git checkout dev
RUN mkdir build

WORKDIR /tmp/librocket.git/build
RUN \
  clang++ --version >> clang.version; \
  cmake --version >> cmake.version;
# CXXFLAGS is used by cmake to init CMAKE_CXX_FLAGS
# CXXFLAGS=-Wno-register; cmake \
RUN cmake \
  -DCMAKE_CXX_STANDARD=14 \
  -DCMAKE_CXX_STANDARD_REQUIRED=on \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DCMAKE_INSTALL_PREFIX=/tmp/vendor/linux/librocket \
  -DBUILD_SAMPLES=off \
  -DBUILD_LUA_BINDINGS=on \
  -DCMAKE_BUILD_TYPE=DEBUG \
../Build
RUN make
RUN make -j1 install

# libsndfile

RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    autoconf \
    autogen \
    automake \
    build-essential \
    bzip2 \
    cmake \
    curl \
    file \
    git \
    git-lfs \
    libasound2t64 \
    libc6 \
    libflac-dev \
    libmp3lame-dev \
    libmpg123-dev \
    libogg-dev \
    libopus-dev \
    libtool \
    libvorbis-dev \
    make \
    pandoc \
    patch \
    pkg-config \
    python3 \
    python3-pip \
    xdg-utils \
    zip \
    zstd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true
RUN git clone \
  "https://github.com/libsndfile/libsndfile.git" \
/tmp/libsndfile.git

WORKDIR /tmp/libsndfile.git
RUN git switch -c 1.0.25 && mkdir build

WORKDIR /tmp/libsndfile.git/build
RUN \
  clang++ --version >> clang.version; \
  cmake --version >> cmake.version;
RUN cmake \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DBUILD_SHARED_LIBS=1 \
  -DCMAKE_INSTALL_PREFIX=/tmp/vendor/linux/libsndfile \
  -DCMAKE_BUILD_TYPE=DEBUG \
  -DBUILD_EXAMPLES=off \
.. 
RUN make
RUN make -j1 install


# openal

# freetype2

# gtest
WORKDIR /tmp/gtest.git
RUN git clone "https://github.com/google/googletest" \
  /tmp/gtest.git
RUN git checkout v1.8.x && mkdir build

WORKDIR /tmp/gtest.git/build
RUN \
  clang++ --version >> clang.version; \
  cmake --version >> cmake.version;
RUN cmake \
  -DCMAKE_C_COMPILER=/usr/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/bin/clang++ \
  -DBUILD_SHARED_LIBS=1 \
  -DCMAKE_INSTALL_PREFIX=/tmp/vendor/linux/gtest \
..
RUN make
RUN make -j1 install

# jsoncpp

WORKDIR /tmp/jsoncpp.git
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    autoconf \
    autogen \
    automake \
    build-essential \
    bzip2 \
    cmake \
    curl \
    file \
    git \
    git-lfs \
    libc6 \
    libtool \
    make \
    patch \
    pkg-config \
    python3 \
    python3-pip \
    xdg-utils \
    zip \
    zlib1g-dev \
    zstd \
    zstd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true
RUN git clone \
  "https://github.com/open-source-parsers/jsoncpp.git" \
/tmp/jsoncpp.git
RUN mkdir -p /tmp/jsoncpp.git/dist
WORKDIR /tmp/jsoncpp.git
#RUN git switch -c svn-release-0.6.0-rc2
# NOTE(JEFF): build compatible with svn-release-0.6.0-rc2
# branch, but not binary compatible
RUN git switch -c v0.7.0 && mkdir build

WORKDIR /tmp/jsoncpp.git/build
RUN \
  clang++ --version >> clang.version; \
  cmake --version >> cmake.version;
WORKDIR /tmp/jsoncpp.git
RUN python3 amalgamate.py
# IMPORTANT(JEFF): The contents of dist is our install prefix
#   /jsoncpp/dist/ -> /vendor/common/jsoncpp

# /vendor is a bind mount that is only available when the end-user
# opts to run this image with a `-v` param
#RUN if findmnt /vendor 1>/dev/null; then  diff -r /jsoncpp/dist /vendor/common/jsoncpp; fi
RUN mkdir -p /tmp/vendor/linux/common/jsoncpp
RUN cp -av /tmp/jsoncpp.git/dist/* /tmp/vendor/linux/common/jsoncpp
#COPY ["/tmp/jsoncpp.git/dist/*", "/tmp/vendor/linux/common/jsoncpp"]

# NOTE(JEFF): The following configuration produces this project
# as a shared library
#RUN cmake \
#  -DCMAKE_INSTALL_PREFIX=/tmp/vendor/common/jsoncpp \
#..
#RUN make
#RUN make -j1 install

# rapidxml

WORKDIR /tmp/rapidxml.git
RUN apt-get update; \
    apt-get install -y --no-install-recommends \
    build-essential \
    curl \
    file \
    git \
    make \
    patch \
    pkg-config \
    zip \
    zlib1g-dev \
    zstd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* \
    && true
RUN git clone \
  "https://github.com/Fe-Bell/RapidXML" \
/tmp/rapidxml.git
WORKDIR /tmp/rapidxml.git
#RUN git checkout master && mkdir build dist
RUN git switch -c 1x && mkdir build #dist

WORKDIR /tmp/rapidxml.git/build
RUN \
  clang++ --version >> clang.version; \
  cmake --version >> cmake.version;
WORKDIR /tmp/rapidxml.git
# alt install
#COPY \
#/rapidxml/RapidXML/*.cpp \
#  /rapidxml/RapidXML/*.hpp \
#  /rapidxml/RapidXML/*.h \
# /rapidxml/dist
# FIXME
RUN mkdir -p /tmp/vendor/linux/common/rapidxml
RUN cp -av /tmp/rapidxml.git/RapidXML/* /tmp/vendor/linux/common/rapidxml
#COPY ["/rapidxml/RapidXML/*", "/tmp/vendor/linux/common/rapidxml"]

# /vendor is a bind mount that is only available when the end-user
# opts to run this image with a `-v` param
#RUN if findmnt /vendor 1>/dev/null; then diff -r /rapidxml/dist /vendor/common/rapidxml/; fi

