FROM lsiobase/alpine:3.8

# MAINTAINER Romancin
MAINTAINER bootldrDNB

ARG BUILD_CORES

# package version
ARG MEDIAINF_VER="18.05"
ARG RTORRENT_VER="0.9.7"
ARG LIBTORRENT_VER="0.13.7"
ARG CURL_VER="7.61.0"
# FLOOD_VER is unused since we are cloning from the git repo.
# ARG FLOOD_VER="master"

# set env
ENV PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
ENV LD_LIBRARY_PATH=/usr/local/lib
ENV PGID
ENV PUID
   
RUN NB_CORES=${BUILD_CORES-`getconf _NPROCESSORS_CONF`} && \
 apk add --no-cache \
        ffmpeg \
        geoip \
        gzip \
        logrotate \
        tar \
        unrar \
        unzip \
        sox \
        wget \
        git \
        libressl \
        binutils \
        findutils \
        zip && \

# install build packages
 apk add --no-cache --virtual=build-dependencies \
        autoconf \
        automake \
        cppunit-dev \
        perl-dev \
        file \
        g++ \
        gcc \
        libtool \
        make \
        ncurses-dev \
        build-base \
        libtool \
        subversion \
        cppunit-dev \
        linux-headers \
        curl-dev \
        libressl-dev && \

# compile curl to fix ssl for rtorrent
cd /tmp && \
mkdir curl && \
cd curl && \
wget -qO- https://curl.haxx.se/download/curl-${CURL_VER}.tar.gz | tar xz --strip 1 && \
./configure --with-ssl && make -j ${NB_CORES} && make install && \
ldconfig /usr/bin && ldconfig /usr/lib && \

# compile libtorrent
apk add -X http://dl-cdn.alpinelinux.org/alpine/v3.6/main -U cppunit-dev==1.13.2-r1 cppunit==1.13.2-r1 && \
cd /tmp && \
mkdir libtorrent && \
cd libtorrent && \
wget -qO- https://github.com/rakshasa/libtorrent/archive/${LIBTORRENT_VER}.tar.gz | tar xz --strip 1 && \
./autogen.sh && ./configure && make -j ${NB_CORES} && make install && \

# compile rtorrent
cd /tmp && \
mkdir rtorrent && \
cd rtorrent && \
wget -qO- https://github.com/rakshasa/rtorrent/archive/${RTORRENT_VER}.tar.gz | tar xz --strip 1 && \
./autogen.sh && ./configure --with-xmlrpc-c && make -j ${NB_CORES} && make install && \

# compile mediainfo packages
 curl -o \
 /tmp/libmediainfo.tar.gz -L \
        "http://mediaarea.net/download/binary/libmediainfo0/${MEDIAINF_VER}/MediaInfo_DLL_${MEDIAINF_VER}_GNU_FromSource.tar.gz" && \
 curl -o \
 /tmp/mediainfo.tar.gz -L \
        "http://mediaarea.net/download/binary/mediainfo/${MEDIAINF_VER}/MediaInfo_CLI_${MEDIAINF_VER}_GNU_FromSource.tar.gz" && \
 mkdir -p \
        /tmp/libmediainfo \
        /tmp/mediainfo && \
 tar xf /tmp/libmediainfo.tar.gz -C \
        /tmp/libmediainfo --strip-components=1 && \
 tar xf /tmp/mediainfo.tar.gz -C \
        /tmp/mediainfo --strip-components=1 && \

 cd /tmp/libmediainfo && \
        ./SO_Compile.sh && \
 cd /tmp/libmediainfo/ZenLib/Project/GNU/Library && \
        make install && \
 cd /tmp/libmediainfo/MediaInfoLib/Project/GNU/Library && \
        make install && \
 cd /tmp/mediainfo && \
        ./CLI_Compile.sh && \
 cd /tmp/mediainfo/MediaInfo/Project/GNU/CLI && \
        make install && \
# cleanup
 apk del --purge \
        build-dependencies && \
 apk del -X http://dl-cdn.alpinelinux.org/alpine/v3.6/main cppunit-dev && \
 rm -rf \
        /tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 51415
VOLUME /config /downloads
