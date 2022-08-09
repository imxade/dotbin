
 { config
 , pkgs
 , user
 , lib
 , ...
 }:

 {
    # Configure the X11 windowing system.
    services = {
	xserver = {
		  enable	 = true;
		  # Configure keymap in X11
#		  layout	 = "us";
#		  xkbOptions	 = "eurosign:e";
#	
#		  # Configure DisplayManager
#		  displayManager = {
#			  lightdm = {
#				  enable = true;
#				  defaultSession = "none+qtile";
#			  };
#		  };

	  	  # Configure DesktopManager
	  	  desktopManager = {
	  	          xterm   = {
	  	        	  enable = false; # Do not install xterm
	  	          };
	  	  };

	  	  # Enable touchpad support
	  	  libinput = {
	  	          enable		= true;
	  	          tapping		= true;
	  	          naturalScrolling	= true;
	  	  };
	};

	# Enable sound.
	sound	= {
	        enable    = true;
	        mediakeys = {
			enable = true;
	        };
	};
    };

    nixpkgs = {
    	config = {
		allowUnfree = true; # To install non-free packages
        };
    };

    environment = {
    		# Define Environment variables to be used System Wide
            	variables = {
            		TERMINAL = "alacritty";
            	};
    
    		# List packages installed in system profile.
#    		packages  = with pkgs; [
    		systemPackages	= with pkgs; [
			gawk		# Text processing Language
			brave		# Browser
			seatd		# elogind Replacement
			xclip		# Clipboard for xorg
			ffmpeg		# Audio Video
			exiftool	# Manipulate Metadata
			alacritty	# Terminal Emulator
			gammastep	# Manage Screen Color Temperature
			btrfs-progs	# Manage BTRFS
    		];
    };

    programs = {
	    home-manager = {
		    enable = true;
	    };
    };

    # GTK Theme
#    gtk = {
#	    enable = true;
#	    theme = {
#		    name = "Dracula";
#		    package = pkgs.dracula-theme;
#	    };
#	    iconTheme = {
#		    name = "Papirus-Dark";
#		    package = pkgs.papirus-icon-theme;
#	    };
#	    font = {
#		    name = "Hurmit Nerd Font Mono Medium";
#	    };
    };
 }
