#! /bin/bash

#
# Author: Badr BADRI © pythops
# License: MIT
#

set -e

BSP=https://developer.download.nvidia.com/embedded/L4T/r32_Release_v7.4/T210/Jetson-210_Linux_R32.7.4_aarch64.tbz2

# Check if the user is not root
if [ "x$(whoami)" != "xroot" ]; then
        printf "\e[31mThis script requires root privilege\e[0m\n"
        exit 1
fi

# Check for env variables
if [ ! $JETSON_ROOTFS_DIR ] || [ ! $JETSON_BUILD_DIR ]; then
	printf "\e[31mYou need to set the env variables \$JETSON_ROOTFS_DIR and \$JETSON_BUILD_DIR\e[0m\n"
	exit 1
fi

# Check if $JETSON_ROOTFS_DIR if not empty
if [ ! "$(ls -A $JETSON_ROOTFS_DIR)" ]; then
	printf "\e[31mNo rootfs found in $JETSON_ROOTFS_DIR\e[0m\n"
	exit 1
fi

# Check if board type is specified
if [ ! $JETSON_NANO_BOARD ]; then
	printf "\e[31mJetson nano board type must be specified\e[0m\n"
	exit 1
fi

sed -i "s/\/dev\/mmcblk0p1/\/dev\/sda1/g" $JETSON_ROOTFS_DIR/boot/extlinux/extlinux.conf

printf "\e[32mBuild the image ...\n"

# Create the build dir if it does not exists
mkdir -p $JETSON_BUILD_DIR

# Download L4T
if [ ! "$(ls -A $JETSON_BUILD_DIR)" ]; then
        printf "\e[32mDownload L4T...       "
        wget -qO- $BSP | tar -jxpf - -C $JETSON_BUILD_DIR
        printf "[OK]\n"

        # Fix nvidia's bugs in various BSP scripts
        case "$BSP" in
            *32.5*)
                # Fix link dereferencing in 32.5 for xavier. Adds "-a" flag to "cp" command.
                # Without it nVidia's script fails to copy any symlinks from rootfs into recovery image which crashes the whole image creation process.
                sed -i 's/cp -f/cp -af/g' "$JETSON_BUILD_DIR/Linux_for_Tegra/tools/ota_tools/version_upgrade/ota_make_recovery_img_dtb.sh"
                ;;
            *32.7*)
                # When preallocating loopback image space for root, nvidia's script uses ((rootfs_size + (rootfs_size /10))
                # In case of a 400MiB rootfs, this causes the same script to fail copying rootfs into the root image.
                # So we arbitraryly preallocate extra 128MiB ((rootfs_size + 128MiB + (rootfs_size / 10))
                sed -i 's/rootfs_size +/rootfs_size + 128 +/g' "$JETSON_BUILD_DIR/Linux_for_Tegra/tools/jetson-disk-image-creator.sh"
                ;;
        esac     
fi

case "$JETSON_NANO_BOARD" in
    jetson-nano-2gb)
        printf "Create image for Jetson nano 2GB board... "
        ROOTFS_DIR=$JETSON_ROOTFS_DIR $JETSON_BUILD_DIR/Linux_for_Tegra/tools/jetson-disk-image-creator.sh \
            -o jetson.img -b jetson-nano-2gb-devkit
        printf "[OK]\n"
        ;;

    jetson-nano)
        nano_board_revision=${JETSON_NANO_REVISION:=300}
        printf "Creating image for Jetson nano board (%s revision)... " $nano_board_revision
        ROOTFS_DIR=$JETSON_ROOTFS_DIR $JETSON_BUILD_DIR/Linux_for_Tegra/tools/jetson-disk-image-creator.sh \
            -o jetson.img -b jetson-nano -r $nano_board_revision
        printf "[OK]\n"
        ;;

    *)
	printf "\e[31mUnknown Jetson nano board type\e[0m\n"
	exit 1
        ;;
esac

printf "\e[32mImage created successfully\n"
printf "Image location ./jetson.img\n"
