#! /bin/bash 

SOURCE_NAME=boost_1_65_1
APPEND=tar.gz
path=$(pwd)
INSTALL_PATH="${path}"
RASPHIAN_ISO="2017-09-07-raspbian-stretch-lite"

RASPHIAN_KERNEL="qemu-rpi-kernel"
download()
{
    # rasphian iso download
    wget   https://downloads.raspberrypi.org/raspbian_lite_latest
    #rasphian kernal download
    git clone  https://github.com/dhruvvyas90/qemu-rpi-kernel.git 
}
build_install()
{
    unzip -p ${RASPHIAN_ISO}."zip"
    sudo mkdir /mnt/raspbian/

    sudo mount -v -o offset=48234496 -t ext4 ${RASPHIAN_ISO}."zip" /mnt/raspbian/
    sudo cat /dev/null  > /mnt/raspbian/etc/ld.so.preload
    sudo umount /mnt/raspbian/
    qemu-system-arm -kernel kernel-qemu-4.4.34-jessie -cpu arm1176 -m 256 -M versatilepb -serial stdio -append "root=/dev/sda2 rootfstype=ext4 rw"  -drive format=raw,file=${RASPHIAN_ISO} -redir tcp:5022::22  -redir tcp:3011::3011 -no-reboot
}
$1
