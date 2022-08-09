 { config
 , lib
 , pkgs
 , ...
 }:
 
 {
#  boot.extraModprobeConfig = ''
#  	options snd slots=snd-hda-intel		# set hda-intel as default card
#  	options snd_hda_intel enable=0,1	# disable first card, but enable the second one
#  '';
#  boot.initrd.availableKernelModules = [ "xhci_hcd" "ahci" "usbhid" "usb_storage" ];
#  boot.initrd.kernelModules = ["nvme"];
#  boot.kernelModules = [ "kvm-intel" "nvme" ];
#  boot.blacklistedKernelModules = [ "snd_pcsp" ];
#  boot.extraModulePackages = [ ];
#  boot.blacklistedKernelModules = [ ];
#
#  fileSystems."/" =
#    { device  = "/dev/disk/by-label/nixos";
#      fsType  = "btrfs";
#      options = ["noatime" "discard" "ssd" "compress=lzo" "space_cache"];
#      noCheck = true;
#    };
#
#  swapDevices =[
#    { device = "/dev/disk/by-uuid/8ef50590-430d-47af-94a8-a8ad09e6cd2c"; }
#  ];
#
#  nix.maxJobs = 4;
#  nix.extraOptions = ''
#    build-cores = 4
#  '';
 }
