#!/bin/sh

STA=$(rpm-ostree status | awk 'NR==3')
CUR=$(printf "${STA}" | awk -F '/' '{printf $2}')
ARK=$(printf "${STA}" | awk -F '/' '{printf $3}')
FLV=$(printf "${STA}" | awk -F '/' '{printf $4}')
NEW=$(ostree remote refs fedora | awk -v ARK=${ARK} -v FLV=${FLV} '!/raw/ && $0 ~ ARK"/"FLV' | awk -F '/' 'END{print $2}' )

if [ $NEW -gt $CUR ]; then
  rpm-ostree rebase fedora:fedora/"${NEW}/${ARK}/${FLV}"
else
  rpm-ostree upgrade
fi

