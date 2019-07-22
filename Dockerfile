FROM debian:buster
WORKDIR /root/
SHELL ["/bin/bash", "-c"]
ENV ARCH arm
ENV CROSS_COMPILE /root/gcc-linaro-6.2.1-2016.11-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-
RUN (apt-get update; apt-get -y upgrade; apt-get -y install build-essential bc liblz4-tool device-tree-compiler wget libncurses5-dev libncursesw5-dev bison flex libssl-dev) >/dev/null 2>&1
RUN wget -q -O - https://releases.linaro.org/components/toolchain/binaries/6.2-2016.11/arm-linux-gnueabihf/gcc-linaro-6.2.1-2016.11-x86_64_arm-linux-gnueabihf.tar.xz | tar xJf -
RUN wget -q -O - https://codeload.github.com/MiSTer-devel/Linux-Kernel_MiSTer/tar.gz/socfpga-4.19-MiSTer | tar xzf -
RUN make -C Linux-Kernel_MiSTer-socfpga-4.19-MiSTer --quiet clean mrproper MiSTer_defconfig zImage modules dtbs
CMD test -f /mnt/MiSTer_config && cp -v /mnt/MiSTer_config Linux-Kernel_MiSTer-socfpga-4.19-MiSTer/.config ;\
    make -C Linux-Kernel_MiSTer-socfpga-4.19-MiSTer --quiet menuconfig zImage modules dtbs ;\
    cat Linux-Kernel_MiSTer-socfpga-4.19-MiSTer/arch/arm/boot/zImage \
    Linux-Kernel_MiSTer-socfpga-4.19-MiSTer/arch/arm/boot/dts/socfpga_cyclone5_de10_nano.dtb \
    > zImage_dtb ;\
    cp -v zImage_dtb /mnt/zImage_dtb ;\
    cp -v Linux-Kernel_MiSTer-socfpga-4.19-MiSTer/.config /mnt/MiSTer_config
