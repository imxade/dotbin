
 { lib
 , pkgs
 , config
 , ...
 }:

 {
    environment = {
	    # Define Environment xorg wide variables
	    variables	= {
		TERMINAL = "alacritty";
	    };

	    # List packages installed in xorg profile.
 	    systemPackages = with pkgs; [
#		seatd		# elogind Replacement
		exiftool	# Manipulate Metadata
 		alacritty	# Terminal Emulator
		gammastep	# Manage Screen Color Temperature
#		brave		# Browser
#		swtpm		# Virtual TPM
		slurp		# wayland region selector
		grim		# wayland screenshot
		wf-recorder	# wayland screen recorder
		wl-clipboard	# wayland clipboard
	    ];
    };

    sound = {					# ALSA sound enable
            enable = false;
            mediaKeys = {			# Keyboard Media Keys
        	enable = true;
            };
    };

    # Virtualization
    virtualisation = {
	    libvirtd = {
		    enable = true;
		    qemu = {
			    ovmf = {
				    enable = true;
#				    packages = [
#				      pkgs.OVMFFull
#				    ];
			    };
#			    swtpm = {
#				    enable = true; 
#			    };
		    };
	    };
    };

    # Configure the X11 windowing system.
    services = {
	    xserver = {
		enable	 = false;
 	    	# Configure DisplayManager
 	    	displayManager = {
 	    	      	defaultSession = "none+qtile";
 	    	        lightdm = {
 	    	      	  enable = false;
 	    	        };
 	    	};

	    	# Configure DesktopManager
	    	desktopManager = {
	    	        xterm   = {
	    	      	  enable = false; # Do not install xterm
	    	        };
	    	};

	    };
    };

#   # QT  Theme
#   qt5 = {
#   	    enable = true;
#           style = "gtk2";
#           platformTheme = "gtk2";
#   };
 }

