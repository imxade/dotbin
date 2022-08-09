
 { config
 , pkgs
 , lib
 , ... 
 }:

 {
    # Configure Qtile for xorg
    services = {
 	# Include Universal xorg Config
 	imports = [ 
 	  ../default.nix
	];

	# Configure the X11 windowing system.
	xserver = {
	  	  # Configure WindowManager
	  	  windowManager = {
				qtile = {
					enable = true;
				};
	  	  };
	};
    };
 }	
