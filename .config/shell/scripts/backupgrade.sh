#!/bin/sh

# unmount everything from /mnt
umount -Rl /mnt

# store the root device as BLK
BLK=$(mount | awk '/ \/ / {printf $1}')

# store the name of root subvol as VOL
VOL=$(mount | awk -F 'subvol=/|)' '/ \/ / {printf $2}')

# mount root device on /mnt
mount "$BLK" /mnt

# delete the previous snapshot
btrfs subvol delete /mnt/snap_"$VOL"

# create snapshot of current system
btrfs subvol snapshot /mnt/"$VOL" /mnt/snap_"$VOL"

# upgrade the system
pacman -Syu                     # For pacman
xbps-install -Syu               # For xbps
apk --update-cache upgrade      # For apk-tools
kiss update                     # For kiss
kiss Upgrade
emaint --auto sync              # For portage
emerge --verbose --update --deep --newuse @world
rpm-ostree upgrade
flatpak update -y               # For flatpak
waydroid upgrade                # For waydroid
