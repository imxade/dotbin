 { config
 , pkgs
 , lib
 , ...
 }:

 {
    hardware = {
	    enableAllFirmware = true;
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
		      intel-media-driver # LIBVA_DRIVER_NAME=iHD
#		      vaapiIntel         # LIBVA_DRIVER_NAME=i965 (older but works better)
		      vaapiVdpau
		      libvdpau-va-gl
		    ];
	    };
    };

    networking = {
	    enableB43Firmware = true;
    };
    
    boot = {
    	extraModprobeConfig = ''
    		options snd slots=snd-hda-intel		# set hda-intel as default card
    	    	options snd_hda_intel enable=0,1	# disable first card, but enable the second one
    	'';
    };
 }
