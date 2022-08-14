
 { lib
 , pkgs
 , config
 , ...
 }:

 {
    home = {
    	    # List packages installed in xorg profile.
            packages = with pkgs; [
#		brave		# Browser
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

#   # GTK Theme
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

