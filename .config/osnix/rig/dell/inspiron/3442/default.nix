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
		bluez-alsa			# Pure Alsa Bluetooth
		shellcheck
		cryptsetup
		lvm2
		exfat
		ntfs3g
           ];
 	   etc = {
#       	# Configure wireplumber   
#       	"wireplumber/bluetooth.lua.d/51-bluez-config.lua".text = ''
#       		bluez_monitor.properties = {
#       			["bluez5.enable-sbc-xq"] = true,
#       			["bluez5.enable-msbc"] = true,
#       			["bluez5.enable-hw-volume"] = true,
#       			["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]"
#       		}
#       	'';
		"asound.conf".text = ''
			pcm_type.bluealsa {
			  lib ${pkgs.bluez-alsa}/lib/alsa-lib/libasound_module_pcm_bluealsa.so
			}
			ctl_type.bluealsa {
			  lib ${pkgs.bluez-alsa}/lib/alsa-lib/libasound_module_ctl_bluealsa.so
			}
		'';
 	   };
   };
  
   networking = {
 	   interfaces  = {
#	   	wlp6s0 	  = {
#	   	useDHCP = true;
#	   	};
	   };
   };

   services = {
	   logind = {
		   lidSwitch = "ignore"; 	# Do not Suspend when Lid is Closed
	   };
	   tlp = {
		   enable = true;		# enable tlp recommended for laptops
		   settings = {
		   };
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
#           pulseaudio = {			# PulseAudio for Audio
#                   enable = true;
#       	    support32Bit = true;
#       	    # Disable Unwanted Modules
#       	    extraConfig = "
#       	      unload-module module-suspend-on-idle
#       	      load-module module-switch-on-connect 
#       	    ";
#       	    extraClientConf = "enable-shm=no";
#       	    daemon = {
#       		    config = {
#       			    enable-memfd = "yes"; 
#       		    };
#       	    };
#	    };
	    # Enable Bluetooth
	    bluetooth = {
		enable   = true;
 		hsphfpd  = {
 		        enable  = true;
 		};
		settings = {
			Policy = {
			    # Auto Enable Bluetooth
			    AutoEnable = "true";
			};
		        General = {
		    	    Enable = "Source,Sink,Media,Socket";
			    ControllerMode = "bredr";
			    # Bluetooth device always visible
#			    DiscoverableTimeout = "0";
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

    systemd = {
            # Profile Specific services
            services = {
        	    unblock_wifi = {
        		enable = true;
    	    		description = "Unblock Wireless Devices";
			after = [ 
			  "wpa_supplicant.service"
			];
			before = [
			  "network.target"
			];
			wants = [
			  "network.target"
			];
        		wantedBy = [
			  "multi-user.target"
        		];
   		    	serviceConfig = {
   		    	    ExecStart = "${pkgs.util-linux}/bin/rfkill unblock wlan";
        	    	};
        	    };
        	    bluealsa = {
        		enable = true;
    	    		description = "start Bluetooth for Pure Alsa";
			after = [ 
        		  "bluetooth.service" 
			];
			before = [
			  "network.target"
			];
			wants = [
			  "network.target"
			];
        		wantedBy = [
			  "multi-user.target"
        		];
   		    	serviceConfig = {
			    Type = "dbus";
			    BusName = "org.bluealsa";
   		    	    ExecStart = "${pkgs.bluez-alsa}/bin/bluealsa";
#  		    	    ExecStop = "pkill bluealsa";
#  		    	    Restart = "on-failure";
        	    	};
        	    };
            };
    };

#   networking = {
#           enableB43Firmware = true;
#   };
    
    boot = {
#	    # Better set the following inside ~/.asoundrc
#	    extraModprobeConfig = ''
#             # set hda-intel as default card
#    	      options snd slots=snd-hda-intel
#             # disable 1st card, enable 2nd card
#   	      options snd_hda_intel enable=0,1
#    	    '';
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
