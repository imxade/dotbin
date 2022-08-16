
 { lib
 , pkgs
 , config
 , nixpkgs
 , ...
 }:

{
  imports = [ 
    # Include Official Hardened Profile
    <nixpkgs/nixos/modules/profiles/hardened.nix> #fix enable ntfs
  ];

  # enable firewall and block all ports
  networking = {
	  firewall = {
		  enable = true;
		  allowedTCPPorts = [];
		  allowedUDPPorts = [];
	  };
  };

  # disable coredump that could be exploited later
  # and also slow down the system when something crash
  systemd = {
	  coredump = {
		  enable = false;
	  };
  };

  # enable firejail
  programs = {
	  firejail = {
		  enable = true;
	  };
  };

  services = {
  	tor = {
		enable = true;
  	        settings = {
			SOCKSPort = [
			   {
				port = 9090;
			   }
			  ];
#			UseBridges = true;
#			ClientTransportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/obfs4proxy";
#			Bridge = "obfs4 IP:ORPort [fingerprint]";
  	        };
  	};

  	# enable antivirus clamav and
  	# keep the signatures' database updated
# 	clamav = {
# 	        daemon = {
# 	      	  enable = true;
# 	        };
# 	        updater = {
# 	      	  enable = true;
# 	        };
# 	};
  };

  # required to run chromium
# security = {
#         chromiumSuidSandbox = {
#       	  enable = true;
#         };
# };
}
