
# docker-simba

FROM debian:stretch

LABEL maintainer="caligari@treboada.net"

ENV HOME_DIR=/usr/local/simba

# system packages
RUN apt-get update \
    && basicDeps=' \
        sudo \
        unrar \
        unzip \
        wget \
        ' \
    develDeps=' \
        autoconf \
        automake \
        bison \
        ckermit \
        cloc \
        cppcheck \
        flex \
        g++ \
        gawk \
        gcc \
        git \
        gperf \
        doxygen \
        help2man \
        lcov \
        libexpat-dev \
        libtool-bin \
        make \
        ncurses-dev \
        pmccabe \
        python \
        python-pip \
        python-pyelftools \
        texinfo \
        valgrind \
        ' \
    avrDeps=' \
        avr-libc \
        avrdude \
        binutils-avr \
        gcc-avr \
        gdb-avr \
        ' \
    armDeps=' \
        bossa-cli \
        gcc-arm-none-eabi \
        ' \
    DEBIAN_FRONTEND=noninteractive \
        apt-get install -qy $basicDeps $develDeps $avrDeps $armDeps \
    && rm -rf /var/lib/apt/lists/*

# python modules
RUN pip install \
        pyserial xpect readchar sphinx breathe sphinx_rtd_theme 

# regular user
RUN useradd --create-home --home-dir $HOME_DIR --shell /bin/bash simba \
    && echo 'simba ALL=(ALL:ALL) NOPASSWD:ALL' > /etc/sudoers.d/simba
USER simba
WORKDIR $HOME_DIR

# ESP32 SDK
RUN xtensa-version='1.22.0-59' \
    && dist-url='https://dl.espressif.com/dl' \
    && dist-tgz="xtensa-esp32-elf-linux64-${$xtensa-version}.tar.gz" \
    && curl "${$dist-url}/${dist-tgz}" | tar xzvf 

# ESP8266 SDK
RUN git clone --recursive https://github.com/pfalcon/esp-open-sdk \
    && pushd . && cd esp-open-sdk && make && popd

# ToDo: download S32 SDK from NXP

