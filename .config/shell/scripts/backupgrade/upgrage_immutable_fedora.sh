#!/bin/bash

STA=$(rpm-ostree status | awk 'NR==3')
read -r CUR ARK FLV <<< "$(awk -F '/' '{print $2, $3, $4}' <<< "$STA")"
NEW=$(ostree remote refs fedora | awk -v ARK="$ARK" -v FLV="$FLV" '!/raw/ && $0 ~ ARK"/"FLV {split($0, a, "/"); ref=a[2]} END{print ref}')

if [[ $NEW -gt $CUR ]]; then
  rpm-ostree rebase "fedora:fedora/$NEW/$ARK/$FLV"
else
  rpm-ostree upgrade
fi
