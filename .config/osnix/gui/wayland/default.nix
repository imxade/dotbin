
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
		slurp		# wayland region selector
		grub		# wayland screenshot
		wf-recorder	# wayland screen recorder
		wl-clipboard	# wayland clipboard
	    ];
    };

    # Configure the X11 windowing system.
    services = {
	    xserver = {
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

