#!/bin/sh

su root -c "sh $HOME/.config/shell/scripts/backupgrade/root.sh" # backup and upgrade distro
rpm-ostree upgrade                                              # upgrade silverblue
flatpak uninstall --unused --delete-data -y
flatpak repair
flatpak update -y # upgrade flatpak
