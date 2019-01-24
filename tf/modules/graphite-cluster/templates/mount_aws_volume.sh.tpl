#!/usr/bin/env bash
DEVICE_FS=`blkid -o value -s TYPE ${DEVICE}`
if [ "`echo -n $DEVICE_FS`" == "" ] ; then
    mkfs.ext4 ${DEVICE}
fi
mkdir -p ${MOUNT_POINT}
echo '${DEVICE} ${MOUNT_POINT} ext4 defaults 0 0' >> /etc/fstab
mount -a
