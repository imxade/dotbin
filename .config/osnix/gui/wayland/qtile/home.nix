
 { lib
 , pkgs
 , config
 , ...
 }:

 {
    home = {
    	    # List packages installed in xorg profile.
            packages = with pkgs; [
 		firefox-wayland		# Browser
#		firefox			# Browser
#		tor-browser-bundle-bin 	# Browser
    	    ];

    	    # Profile Wide Cursor Theme, so Applications will Not be Able to Choose their Own
#   	    pointerCursor = {
#   		name = "Dracula-cursors"; #fix Canta
#   		package = pkgs.dracula-theme;
#   		size = 14;
#   	    };
    };

    programs = {
            home-manager = {
        	    enable = true;
            };
    };

    # Using Bluetooth headset buttons to control media player
#   systemd = {
#           user = {
#       	    services = {
#       		    mpris-proxy = {
#       			    Unit = {
#       				    Description = "Mpris proxy";
#       				    After = [
#       				      "network.target"
#       				      "sound.target" 
#       				    ];
#       			    };
#       		    };
#       		    ExecStart = "${pkgs.bluez}/bin/mpris-proxy";
#       		    Install = {
#       			    WantedBy = [
#       			      "default.target"
#       			    ];
#       		    };
#       	    };
#           };
#   };

    # GTK Theme
#   gtk = {
#	    enable = true;
#	    theme = {
#   		name = "Dracula-cursors";
#   		package = pkgs.dracula-theme;
#	    };
#	    theme = {
#		name = "Canta-dark";
#		package = pkgs.canta-theme;
#	    };
#	    iconTheme = {
#		name = "Papirus-Dark";
#		package = pkgs.papirus-icon-theme;
#	    };
#	    font = {
#		name = "Hermit Nerd Font Mono Medium";
#	    };
#   };
 }

