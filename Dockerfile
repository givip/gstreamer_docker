FROM ubuntu:xenial

RUN apt-get update
RUN apt-get install -y git wget python3 python3-pip pkg-config ninja-build \
    flex bison \
    libmount-dev zlib1g-dev libunwind-dev libdw-dev libbz2-dev libsqlite3-dev libssl-dev \
    libsoup2.4-dev libselinux1-dev \
    librtmp-dev

RUN wget https://github.com/Kitware/CMake/releases/download/v3.15.7/cmake-3.15.7-Linux-x86_64.tar.gz
RUN tar zxf cmake-3.15.7-Linux-x86_64.tar.gz
RUN cp -rf /cmake-3.15.7-Linux-x86_64/bin /usr/local/
RUN cp -rf /cmake-3.15.7-Linux-x86_64/doc /usr/local/
RUN cp -rf /cmake-3.15.7-Linux-x86_64/man /usr/local/share/
RUN cp -rf /cmake-3.15.7-Linux-x86_64/share /usr/local/
RUN cmake --version

RUN git clone --branch libpng16 git://git.code.sf.net/p/libpng/code libpng16
RUN cd libpng16 && ./configure && make && make install

RUN pip3 install --user "meson>=0.50"
ENV PATH="/root/.local/bin:${PATH}"

RUN git clone --branch 1.16.2 https://gitlab.freedesktop.org/gstreamer/gst-build.git

WORKDIR "/gst-build"
RUN meson --prefix=/dd-gstreamer -Dlibnice=disabled -Dvaapi=disabled build/
RUN ninja -C build/