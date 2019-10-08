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

Don't forget to setup a directory to store the compilation result on your host machine. Mount that directory as one of the volume of the container using `/root/raspberrypi` as the mount point. For example, I'm going to use the `raspberrypi-linux` directory in my home directory.

```sh
docker run --name rpi-cross-compile-kernel -it \
 -v $HOME/raspberrypi-linux:/root/raspberrypi \
 rpi-cross-compile:latest \
 /bin/bash
```

A new container with name `rpi-cross-compile-kernel` will be created and a new bash session will be opened.

## Getting the Kernel Source Code

You can get the source code by cloning the whole repository at `https://github.com/raspberrypi/linux`.
```sh
git clone https://github.com/raspberrypi/linux
```

If you prefer to get the source code at a specific branch only, then run the following command:

```sh
git clone --depth=1 --branch rpi-4.18.y https://github.com/raspberrypi/linux
```

In the example above, the branch that we'll get is rpi-4.18.y which means we will get the source code for linux kernel version 4.18. If you prefer another version, then just change the branch name to match your prefered kernel version.

## Building the Kernel

You can follow the guide on the [official documentation](https://www.raspberrypi.org/documentation/linux/kernel/building.md).

The steps are pretty much the same as the guide on the official documentation.

Here's what I did

1. Configuring kernel for target, in this case I'm targetting a Compute Module 3

```sh
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- bcm2709_defconfig
```

2. Run `menuconfig` to configure the kernel, you can skip this step if you think it's not necessary. For me, it is necessary because I need to enable a staging driver.

```sh
make ARCH=arm CROSS_COMPILE=arm-linux-gnueabihf- menuconfig
```

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

5. If you need to compile a driver source code based on the kernel that you just compiled yourself, see [this guide](https://forum.loverpi.com/discussion/555/how-to-fix-dkms-error-bin-sh-1-scripts-basic-fixdep-exec-format-error). Basically we need to compile the scripts in the Raspberry Pi instead of in our host machine.