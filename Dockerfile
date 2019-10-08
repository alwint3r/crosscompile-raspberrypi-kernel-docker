FROM ubuntu:xenial

WORKDIR /root/raspberrypi

RUN dpkg --add-architecture i386 && \
    apt update && \
    apt install -y git build-essential bc bison flex libssl-dev \
                u-boot-tools lzop fakeroot gcc-multilib \
                zlib1g:i386 libncurses5-dev vim kmod

RUN git clone https://github.com/raspberrypi/tools /root/tools && \
    echo PATH=\$PATH:~/tools/arm-bcm2708/gcc-linaro-arm-linux-gnueabihf-raspbian-x64/bin >> /root/.bashrc

CMD ["/bin/bash"]
