Cross-compiling Raspberry Pi Kernel on a Docker Container
=========================================================

An ubuntu 16.04-based environment for cross-compiling Raspberry Pi kernel.

## Why?

Isolation. I need it so bad because I screwed up my host environment.

## Pros & Cons

**Pros**

* Faster build time, assuming your machine is far more powerful than a Raspberry Pi


**Cons**

* Installing newly built kernel isn't that simple, especially if you're targetting a Raspberry Pi Compute Module board.



It's a lot simpler if you build the kernel on the Pi itself, but the whole process can take hours to finish.

## Starting the Container

Clone the repository

```sh
git clone https://github.com/alwint3r/raspberrypi-kernel-crosscompile
```

Move to the cloned repository, then build the docker image.
```sh
docker build -t rpi-cross-compile:latest .
```

Choose the branch of the kernel that you want to build. For example, I somehow neeed to compile the kernel with version 4.14, so I need to use the rpi-4.14.y branch.

Also don't forget to setup a directory to store the compilation result on your host machine. Mount that directory as one of the volume of the container using `/root/raspberrypi` as the mount point. For example, I'm going to use the `raspberrypi-linux` directory in my home directory.

```
docker run --name rpi-cross-compile-kernel -it \
 -e LINUX_BRANCH=rpi-4.14.y \
 -v $HOME/raspberrypi-linux:/root/raspberrypi \
 rpi-cross-compile:latest \
 /bin/bash
```

A new container with name `rpi-cross-compile-kernel` will be created and a new bash session will be opened.

## Building the Kernel

You can follow the guide on the [official documentation](https://www.raspberrypi.org/documentation/linux/kernel/building.md).

The steps are pretty much the same as the guide on the official documentation.

Here's what I did

1. Configuring kernel for target, in this case I'm targetting a Compute Module 3

```sh
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
```

2. Run `make menuconfig` to configure the kernel, you can skip this step if you think it's not necessary. For me, it is necessary because I need to enable a staging driver.

3. Start building the kernel image, modules, and device trees

```sh
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- zImage modules dtbs
```

Yes, you can use `j N` flagh with N is the number of jobs that will be run at the same time.

4. As for installing the modules, I need to copy the entire linux source code to my Raspberry Pi and then run the modules installation there. As for why, copying symlinks to a different filesystem (USB stick drive) is annoying and dealing with symlinks in gerenal is stressing me.

In the Raspberry Pi terminal, inside the linux kernel directory
```sh
sudo make install_modules

```


