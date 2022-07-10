#!/bin/sh
umount -Rl /mnt
PRT=$(mount | awk '/ on \/ / {printf $1}')
VOL=$(awk -F "\/| " '/ \/ / {print $9; exit;}' /etc/fstab)
mount "$PRT" /mnt
rm -rf /mnt/snap_"$VOL";
btrfs subvol snapshot /mnt/"$VOL" /mnt/snap_"$VOL" &&
pacman -Syu --noconfirm
