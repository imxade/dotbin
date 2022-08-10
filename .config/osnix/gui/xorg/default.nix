
 { config
 , pkgs
 , user
 , lib
 , ...
 }:

 {
    home = {
#	    systemPackages = with pkgs; [
	    packages = with pkgs; [
    		# List packages installed in xorg profile.
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

    # Configure the X11 windowing system.
    services = {
	    xserver = {
		    enable	 = true;
	    	    # Configure keymap in X11
#	    	    layout	 = "us";
#	    	    xkbOptions	 = "eurosign:e";
#	    	    
#	    	    # Configure DisplayManager
#	    	    displayManager = {
#	    	            lightdm = {
#	    	          	  enable = true;
#	    	          	  defaultSession = "none+qtile";
#	    	            };
#	    	    };

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
    };

#   programs = {
#           home-manager = {
#       	    enable = true;
#           };
#   };

#   # GTK Theme
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
#   };
 }

