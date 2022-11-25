# build with 
#   docker build --build-arg GHDL_BRANCH=<SOME BRANCH NAME> -t ghdl:<SOME BRANCH NAME> .
# run with 
#   docker run -ite DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --user=1001:100 -v <PATH_TO_LOCAL_CODE>:/repo ghdl:master

FROM ubuntu:20.04

ARG GHDL_BRANCH

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    # GHDL prerequisites
    git \
    gnat \
    build-essential \
    curl \
    tcl8.6-dev \
    tcl8.6 \
    tk8.6-dev \
    tk8.6 \
    gperf \
    autotools-dev \ 
    automake \
    libgtk2.0-dev \
    flex \
    zlib1g-dev \
    wget \
    # Vunit prerequisites
    python3 \
    python3-pip

RUN git clone https://github.com/ghdl/ghdl.git --depth 1 --branch ${GHDL_BRANCH} && \
    git clone https://github.com/gcc-mirror/gcc.git --depth 1 --branch releases/gcc-11.2.0 --single-branch && \
    git clone https://github.com/gtkwave/gtkwave.git --depth 1 --single-branch && \
    cd gcc && ./contrib/download_prerequisites

RUN cd ghdl && \
    mkdir build && \
    cd build && \
    ../configure --with-gcc=../../gcc --prefix=/usr/local && \
    make copy-sources && \
    mkdir gcc-objs; cd gcc-objs && \
    ../../../gcc/configure --prefix=/usr/local --enable-languages=c,vhdl \
    --disable-bootstrap --disable-lto --disable-multilib --disable-libssp \
    --disable-libgomp --disable-libquadmath --enable-default-pie && \
    make -j4 && make install MAKEINFO=true && \
    cd .. && \
    make ghdllib && \
    make install 

RUN apt-get update -qq && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get -y install --no-install-recommends \
    libbz2-dev

RUN cd gtkwave/gtkwave3 && \
    ./configure --enable-gtk3 --with-tcl=/usr/lib/tcl8.6/ --with-tk=/usr/lib/tk8.6/ --disable-xz && \
    make && \
    make install

RUN pip3 install vunit-hdl

ARG DISPLAY

SHELL ["/bin/bash", "-c"]