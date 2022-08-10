
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
		xclip		# Clipboard for xorg
		ffmpeg		# Audio Video
		exiftool	# Manipulate Metadata
 		alacritty	# Terminal Emulator
		gammastep	# Manage Screen Color Temperature
	    ];
    };

    # Configure the X11 windowing system.
    services = {
	    xserver = {
		enable	 = true;
	    	# Configure keymap in X11
#	    	layout	 = "us";
#	    	xkbOptions	 = "eurosign:e";
#	    	
#	    	# Configure DisplayManager
#	    	displayManager = {
#	    	      	defaultSession = "none+qtile";
#	    	        lightdm = {
#	    	      	  enable = true;
#	    	        };
#	    	};

	    	# Configure DesktopManager
	    	desktopManager = {
	    	        xterm   = {
	    	      	  enable = false; # Do not install xterm
	    	        };
	    	};

	    	# Enable touchpad support
	    	libinput = {
	    	        enable   = true;
			touchpad = {
				tapping	= true;
				naturalScrolling = true;
			};
		};
	    };
    };

    # QT  Theme
    qt5 = {
    	    enable = true;
            style = "gtk2";
            platformTheme = "gtk2";
    };
 }

