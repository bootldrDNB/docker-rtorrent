FROM lsiobase/alpine:3.8

# MAINTAINER Romancin
MAINTAINER bootldrDNB

ARG BUILD_CORES

# package version
ARG RTORRENT_VER="0.9.7"
ARG LIBTORRENT_VER="0.13.7"

# set env
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV PGID=1000
ENV PUID=1000

RUN NB_CORES=${BUILD_CORES-`getconf _NPROCESSORS_CONF`} \
 && apk -U upgrade \
 && apk add -t build-dependencies \
    build-base \
    git \
    libtool \
    automake \
    autoconf \
    wget \
    tar \
    xz \
    zlib-dev \
    cppunit-dev \
    libressl-dev \
    ncurses-dev \
    curl-dev \
    binutils \
    linux-headers \
 && apk add \
    ca-certificates \
    curl \
    dtach \
    ncurses \
    libressl \
    gzip \
    zip \
    zlib \
    python \
    unrar \
    findutils \
    mktorrent \
    mediainfo \
 && cd /tmp && mkdir libtorrent rtorrent \
 && cd libtorrent && wget -qO- https://github.com/rakshasa/libtorrent/archive/v${LIBTORRENT_VER}.tar.gz | tar xz --strip 1 \
 && cd ../rtorrent && wget -qO- https://github.com/rakshasa/rtorrent/releases/download/v${RTORRENT_VER}/rtorrent-${RTORRENT_VER}.tar.gz | tar xz --strip 1 \
 && cd /tmp \
 && git clone https://github.com/mirror/xmlrpc-c.git \
 && cd /tmp/xmlrpc-c/advanced && ./configure && make -j ${NB_CORES} && make install \
 && cd /tmp/libtorrent && ./autogen.sh && ./configure && make -j ${NB_CORES} && make install \
 && cd /tmp/rtorrent && ./autogen.sh && ./configure --with-xmlrpc-c && make -j ${NB_CORES} && make install \
 && strip -s /usr/local/bin/rtorrent \
 && apk del build-dependencies \
 && rm -rf /var/cache/apk/* /tmp/*

   
# add local files
COPY root/ /

# ports and volumes
EXPOSE 51415
VOLUME /config /downloads
