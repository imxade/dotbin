 { lib
 , pkgs
 , config
 , ...
 }:

 {
   environment = {
           # List packages installed for inspiron_3442
           systemPackages = with pkgs; [
 		btrfs-progs 			# Manage BTRFS
           ];
	   etc = {
		# Configure wireplumber   
		"wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
			bluez_monitor.properties = {
				["bluez5.enable-sbc-xq"] = true,
				["bluez5.enable-msbc"] = true,
				["bluez5.enable-hw-volume"] = true,
				["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
			}
		'';
	   };
   };

  security = {
	  rtkit = {
		  enable = true;
	  };
  };

  sound = {					# ALSA sound enable
    enable = true;
    mediaKeys = {				# Keyboard Media Keys (for minimal desktop)
      enable = true;
    };
  };

   services = {
	   logind = {
		   lidSwitch = "ignore"; 	# Do not Suspend when Lid is Closed
	   };
#	   pipewire = {				# Pipewire for Audio 	
#		   enable = true;
#		   alsa = {
#			   enable = true;
#			   support32Bit = true;
#		   };
#		   pulse = {
#			   enable = true;
#		   };
#	   };
   };

   hardware = {
            enableAllFirmware = true;
            pulseaudio = {			# PulseAudio for Audio
                    enable = true;
        	    support32Bit = true;
        	    # Disable Unwanted Modules
        	    extraConfig = "
		      unload-module module-suspend-on-idle
		      load-module module-switch-on-connect 
		    ";
		    extraClientConf = "enable-shm=no";
		    daemon = {
			    config = {
				    enable-memfd = "yes"; 
			    };
		    };
 	    };
	    # Enable Bluetooth
	    bluetooth = {
		enable   = true;
		hsphfpd  = {
		        enable  = true;
		};
		settings = {
		        General = {
		    	    Enable ="Source,Sink,Media,Socket";
		        };
		};
	    };
	    opengl = {
		enable = true;
		extraPackages = with pkgs; [
		  intel-media-driver 		# LIBVA_DRIVER_NAME=iHD
#		  vaapiIntel         		# LIBVA_DRIVER_NAME=i965 (older but better for browsers)
		  vaapiVdpau
		  libvdpau-va-gl
		];
	    };
    };

#   networking = {
#           enableB43Firmware = true;
#   };
    
    boot = {
 	    extraModprobeConfig = ''
	      # set hda-intel as default card
     	      options snd slots=snd-hda-intel
	      # disable 1st card, enable 2nd card
    	      options snd_hda_intel enable=0,1
     	    '';
 	    kernelModules = [
 	      "wl" 
 	    ];
 	    extraModulePackages = [
 	      config.boot.kernelPackages.broadcom_sta
 	    ];
#	    blacklistedKernelModules = [
#	      "b43" 
#	      "bcma" 
#	    ];
#	    kernelModules = [
#	      "kvm-intel"
#	      "nvme"
#	    ];
#	    initrd ={
#	      availableKernelModules = [ 
#		"ahci" 
#		"usbhid"
#	        "xhci_hcd"
#		"usb_storage" 
#	      ];
#	    kernelModules = [
#	      "nvme"
#	    ];
    };
 }
