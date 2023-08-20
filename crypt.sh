#!/bin/bash

VG_NAME="vg01"
LV_NAME="lv_volume"
MOUNT_POINT="/mnt/data"
CRYPT_NAME="data"
KEY_FILE="/root/luks_keyfile"

# Check if physical volume is not created
if ! pvdisplay /dev/nvme1n1 &>/dev/null; then
    # Create physical volume
    pvcreate /dev/nvme1n1
fi

# Check if volume group is not created
if ! vgdisplay $VG_NAME &>/dev/null; then
    # Create volume group
    vgcreate $VG_NAME /dev/nvme1n1
fi

# Check if logical volume is not created
if ! lvdisplay /dev/$VG_NAME/$LV_NAME &>/dev/null; then
    # Create logical volume
    lvcreate -l 100%FREE -n $LV_NAME $VG_NAME
fi

# Check if key file doesn't exist, generate and store key
if [ ! -f $KEY_FILE ]; then
    LUKS_KEY=$(openssl rand -base64 32)
    echo -n "$LUKS_KEY" > $KEY_FILE
    chmod 0400 $KEY_FILE
else
    LUKS_KEY=$(cat $KEY_FILE)
fi

# Open the encrypted volume if not already opened
if ! cryptsetup status $CRYPT_NAME &>/dev/null; then
    # Format the logical volume with LUKS encryption using the generated key
    echo -n "$LUKS_KEY" | cryptsetup --batch-mode luksFormat /dev/$VG_NAME/$LV_NAME

    # Open the encrypted volume using the stored key
    echo -n "$LUKS_KEY" | cryptsetup luksOpen /dev/$VG_NAME/$LV_NAME $CRYPT_NAME
fi

# Check if the file system is not already created
if ! file -sL /dev/mapper/$CRYPT_NAME | grep -q "ext4"; then
    # Create file system on the encrypted volume
    mke2fs -t ext4 -j -O dir_index /dev/mapper/$CRYPT_NAME
fi

# Tune the file system parameters if not tuned already
if ! tune2fs -l /dev/mapper/$CRYPT_NAME | grep -q "Reserved block count:.*0"; then
    # Tune the file system parameters
    tune2fs -m 0 -c -1 -i 0 -o journal_data_writeback -O ^has_journal /dev/mapper/$CRYPT_NAME
fi

# Create mount point if not exists
if [ ! -d $MOUNT_POINT ]; then
    mkdir -p $MOUNT_POINT
fi

# Mount the encrypted file system if not already mounted
if ! mountpoint -q $MOUNT_POINT; then
    # Mount the encrypted file system
    mount /dev/mapper/$CRYPT_NAME $MOUNT_POINT
fi

# Update /etc/crypttab if entry doesn't exist
if ! grep -q "$CRYPT_NAME" /etc/crypttab; then
    echo "$CRYPT_NAME /dev/$VG_NAME/$LV_NAME $KEY_FILE luks" >> /etc/crypttab
fi

# Update /etc/fstab if entry doesn't exist
if ! grep -q "$MOUNT_POINT" /etc/fstab; then
    echo "/dev/mapper/$CRYPT_NAME $MOUNT_POINT ext4 defaults 0 0" >> /etc/fstab
fi

# Recreate initramfs image to include the key file
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)
