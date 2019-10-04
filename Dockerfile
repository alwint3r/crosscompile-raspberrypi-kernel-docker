FROM ubuntu:xenial

WORKDIR /root/raspberrypi

RUN apt update && \
    dpkg --add-architecture i386 && \
    apt install git build-essential bc bison flex libssl-dev \
                u-boot-tools lzop fakeroot gcc-multilib \
                zlib1g:i386 libncurses5-dev

RUN git clone https://github.com/raspberrypi/tools ~/tools && \
    echo PATH=\$PATH:~/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian/bin >> ~/.bashrc && \
    source ~/.bashrc

ENV LINUX_BRANCH=rpi-4.14.y

RUN git clone --depth=1 --branch ${LINUX_BRANCH} https://github.com/raspberrypi/linux

CMD ["/bin/bash"]
