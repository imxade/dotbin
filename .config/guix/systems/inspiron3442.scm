(use-modules (nongnu packages linux))

(operating-system
  (kernel linux)
  ;; Blacklist conflicting kernel modules.
  (kernel-arguments '("modprobe.blacklist=b43,b43legacy,ssb,bcm43xx,brcm80211,brcmfmac,brcmsmac,bcma"))
  (kernel-loadable-modules (list broadcom-sta))
  (firmware (cons* broadcom-bt-firmware
                   %base-firmware))
