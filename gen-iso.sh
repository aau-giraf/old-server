#!/bin/sh

MIRROR=http://ftp.klid.dk/ftp/centos/7/isos/x86_64/
ISO_NAME=CentOS-7-x86_64-NetInstall-1611
ISO_FILE=$ISO_NAME.iso

MOUNT_DIR=/mnt/iso
TMP_DIR=$(pwd)/tmp
BUILD_DIR=$TMP_DIR/build

# Download iso
mkdir -p $TMP_DIR
if [ ! -f "$TMP_DIR/$ISO_FILE" ]; then
    wget $MIRROR/$ISO_FILE -O$TMP_DIR/$ISO_FILE
fi

# Extract iso
sudo mkdir -p $MOUNT_DIR
sudo mount -o loop $TMP_DIR/$ISO_FILE $MOUNT_DIR
rm -rf $BUILD_DIR
mkdir $BUILD_DIR
cp -r $MOUNT_DIR/* $BUILD_DIR
chmod -R u+w $BUILD_DIR
sudo umount $MOUNT_DIR && sudo rmdir $MOUNT_DIR

# Setup kickstar files
cp *.cfg $BUILD_DIR/isolinux/
sed -i 's/append\ initrd\=initrd.img/append initrd=initrd.img\ ks\=cdrom:\/centos7-master.cfg/' $BUILD_DIR/isolinux/isolinux.cfg
pushd $BUILD_DIR > /dev/null 2>&1
mkisofs -R -J -v -T \
 -o /tmp/boot.iso \
 -b isolinux.bin -c boot.cat \
 -V 'CentOS 7 x86_64' \
 -no-emul-boot -boot-load-size 4 -boot-info-table \
 isolinux/. $BUILD_DIR
popd > /dev/null 2>&1

# Generate image



#7za x $ISO_FILE -o$BUILD_DIR/
#7za x $BUILD_DIR/$ISO_NAME -o$BUILD_DIR/
