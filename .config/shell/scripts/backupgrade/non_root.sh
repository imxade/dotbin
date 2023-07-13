#!/bin/sh

su root -c "sh $HOME/.config/shell/scripts/backupgrade/root.sh" # backup and upgrade distro
sh $HOME/.config/shell/scripts/backupgrade/upgrage_immutable_fedora.sh
flatpak uninstall --unused --delete-data -y
flatpak repair
flatpak update -y # upgrade flatpak
