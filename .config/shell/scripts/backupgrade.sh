#!/bin/sh
umount -Rl /mnt
PRT=$(mount | awk '/ \/ / {printf $1}')
VOL=$(mount | awk -F 'subvol=/|)' '/ \/ / {printf $2}')
mount "$PRT" /mnt
btrfs subvol delete /mnt/snap_"$VOL"
btrfs subvol snapshot /mnt/"$VOL" /mnt/snap_"$VOL" &&
pacman -Syu --noconfirm
