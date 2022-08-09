{

 description = "Have Some Flake";

 # Define All Flake references to be used for building NixOS setup. These are dependencies.
 inputs = rec {

	# set the channel
        nixpkgs	= {
	        url = "nixpkgs/nixos-unstable";
	};

        # master channel for packages on the edge
        nixmaster	= {
	        url = "github:NixOS/nixpkgs";
	};

        # enable home-manager
        home-manager	= {
	        url = "github:nix-community/home-manager/master";
	        # tell home manager to use the nixpkgs channel set above.
	        inputs = {
	       	 nixpkgs = {
	       		 follows = "nixpkgs";
	       	 };
	        };
	};

	nixos-hardware	= {
		url = "github:nixos/nixos-hardware";
	};
 };
 
 # Tell Flake what to use and what to do with the dependencies.
 outputs = { self	#fix
	   , nixpkgs
	   , home-manager
	   , nixos-hardware
	   , ... 
 } @ inputs:

  # The following Variables are defined for the Ease of Modification.
  let 
    RIG 	= "dell/inspiron/3442";				# Profile of machine to be used
    GUI		= "xorg/qtile";					# Graphical Environment
#   GUI		= "wayland/qtile"
    USER 	= "x";						# Username
    HOST	= "dell";					# Hostname for the system
    ZONE 	= "Asia/Kolkata"; 				# Set your time zone
    DISK 	= "/dev/sda"; 					# Disk for Boot Loader
    FUID 	= "B3CE-491A"; 					# UUID of Fat partition holding grub.cfg
    RUID 	= "7f21a58f-01c1-45c6-9081-911b62624dcd";	# UUID of Root device, To Hibernate
#   FUID 	= "$(findmnt /fat -n -o uuid)"; 		# UUID of Fat partition holding grub.cfg
#   RUID 	= "$(findmnt / -n -o uuid)";			# UUID of Root device, To Hibernate #fix
    OFFSET	= "";						# Offset value of swapfile, To Hibernate
    system 	= "x86_64-linux";				# Platform #fix
#   system 	= "$(uname -m)-linux";
#   system	= builtins.currentSystem;			#fix check if works instead of x86_64-linux
    lib	 	= nixpkgs.lib;
    pkgs   	= import nixpkgs {
  	  inherit system;
  	  config = {
  		  allowUnfree = true;
  	  };
    };
  in								# Use Above variables in ...
  {
	nixosConfiguration = {
#	        NIXOS = lib.nixosSystem {
 	        nixos = lib.nixosSystem {
	      	  inherit system pkgs;
                  modules = [
		    # If Path to File is specified, it will be imported
		    # If Path to Directory is specified, 'default.nix' inside that will be imported

		    # add your model from this list: https://github.com/NixOS/nixos-hardware/blob/master/flake.nix
#		    nixos-hardware.nixosModules.dell-xps-13-9380

	      	    # Include the results of the hardware scan.
	      	    /etc/nixos/hardware-configuration.nix

	      	    # Include Machine Profile
#	      	    ./rig/${RIG}/default.nix	#fix
	      	    ./rig/${RIG}

	      	    # configuration.nix : Universal System Configuration for all Profiles
	      	    (
		    { config
		    , pkgs
		    , lib
		    , ...
		    }: 
		    {
	      	       boot = {
				# Hibernate Options
				kernelParams = [
				  "resume_offset=${OFFSET}"
				];
				resumeDevice = "/dev/disk/by-uuid/${RUID}";

	      	        	# Configure boot loader
	      	        	loader = { 
	      	             		grub 	= {
	      	             			version 		= 2;
	      	             			enable 			= true;
	      	             			efiSupport 		= true;
	      	             			useOSProber 		= true;
	      	             			enableCryptodisk 	= true;
	      	             			efiInstallAsRemovable 	= true;
	      	             			device 			= "${DISK}";
	      	             			extraEntries 		= ''
	      	             				menuentry "OTHER" {
	      	             				search --set=root --fs-uuid ${FUID}
	      	             				configfile /grub/grub.cfg }'';
	      	             		};
	      	             		efi 	= {
	      	             			efiSysMountPoint 	= "/fat"; # Mount Point for Fat Partition
	      	             		};
	      	             		timeout = 2; # wait this much before auto-boot
	      	        	};
	      	       };
	      	       
	      	       networking = {
	      	       	hostName    = "${HOST}"; # Define your hostname.
	      	       	wireless    = {
	      	       		enable = true;  # Enables wireless support via wpa_supplicant.
	      	       	};
	      	       	nameservers = [
	      	                 "9.9.9.9"
	      	       	];

	      	       	# The global useDHCP flag is deprecated, therefore explicitly set to false here.
	      	       	# Per-interface useDHCP will be mandatory in the future, so this generated config
	      	       	# replicates the default behaviour.
	      	       	useDHCP     = false;
	      	       	interfaces  = {
	      	       		eth0 	= {
	      	       			useDHCP = true;
	      	       		};
	      	       		wlan0 	= {
	      	       			useDHCP = true;
	      	       		};
	      	       	};

	      	       	# Configure network proxy if necessary
#	      	       	proxy	   = {
#	      	       		default = "http://user:password@proxy:port/";
#	      	       		noProxy = "127.0.0.1,localhost,internal.domain";
#	      	       	};
	      	       };
	      	       
	      	       time	= {
	      	               timeZone = "${ZONE}"; # Set your time zone.
	      	       };
	      	       
	      	       # Select internationalisation properties.
	      	       i18n	= {
	      	               defaultLocale = "en_US.UTF-8";
	      	       };
	      	       
	      	       console  = {
			       font   = "Lat2-Terminus16";
			       keyMap = "us";
	      	       };

		       # System Fonts
	      	       fonts	= {
	      	               fonts = with pkgs; [
	      	                 (nerdfonts.override { 
	      	             	    fonts = [ 
	      	             	      "Hurmit" 
	      	             	    ]; })
	      	               ];
	      	       };
	      	       
		       # Enable sound
		       sound	= {
			       enable    = true;
			       mediakeys = {
				       enable = true;
			       };
		       };

	      	       # Define a user account. Don't forget to set a password with ‘passwd’.
	      	       users	= {
	      	               users = {
	      	             	  ${USER} = {
#	      	       		  initialPassword	= "password";	# Password for the user
	      	             		  isNormalUser	= true;
	      	             		  extraGroups 	= [
	      	             		    "seat"
	      	             		    "seatd"
	      	             		    "wheel"
	      	             		    "audio"
	      	             		    "video"
	      	             		    "input"
					    "camera"
	      	             		    "scanner"
	      	             		  ];
		       		  shell = pkgs.zsh;			# Default shell
	      	             	  };
	      	               };
	      	       };
	      	       
	      	       security = {
	      	               sudo = {
	      	             	  enable = false; # Disable sudo
	      	               };
	      	       };
	      	       
	      	       # Configure SystemWide services
	      	       services = {
#	      	               # Enable CUPS to print documents.
#	      	               printing = {
#	      	       		enable = true;
#	      	               };

#			       # Sound
#			       pipewire = {
#			         enable = true;
#			         alsa = {
#			           enable = true;
#			           support32Bit = true;
#			         };
#			         pulse.enable = true;
#			       };

#	      	               # Enable the OpenSSH daemon.
#			       openssh = {                              # SSH: secure shell (remote connection to shell of server)
#			         enable = true;                         # local: $ ssh <user>@<ip>
#			                                                # public:
#			                                                #   - port forward 22 TCP to server
#			                                                #   - in case you want to use the domain name insted of the ip:
#			                                                #       - for me, via cloudflare, create an A record with name "ssh" to the correct ip without proxy
#			                                                #   - connect via ssh <user>@<ip or ssh.domain>
#			                                                # generating a key:
#			                                                #   - $ ssh-keygen   |  ssh-copy-id <ip/domain>  |  ssh-add
#			                                                #   - if ssh-add does not work: $ eval `ssh-agent -s`
#			         allowSFTP = true;                      # SFTP: secure file transfer protocol (send file to server)
#			                                                # connect: $ sftp <user>@<ip/domain>
#			                                                # commands:
#			                                                #   - lpwd & pwd = print (local) parent working directory
#			                                                #   - put/get <filename> = send or receive file
#			         extraConfig = ''
#			           HostKeyAlgorithms +ssh-rsa
#			         '';                                    # Temporary extra config so ssh will work in guacamole
#			       };
#
#			       # Enable Flatpak
#			       flatpak = {
#				       enable = true;
#			       };
#	      	       };
#
#		       xdg.portal = {					# Required for flatpak
#			       enable = true;
#			       extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
#		       };


	      	       nixpkgs = {
	      	               config = {
	      	             	  allowUnfree = true; # To install non-free packages
	      	               };
	      	       };

	      	       environment = {
	      	               # Define Environment variables to be used System Wide
	      	               variables	= {
	      	       			EDITOR	 = "nvim";
	      	             	  	VISUAL	 = "nvim";
            				TERMINAL = "alacritty";
	      	               };

	      	       	# List packages installed in system profile.
	      	               defaultPackages	= [];	# Do not install anything by default
	      	               systemPackages	= with pkgs; [
	      	             		git		# To take Care of Git repositories
					gawk		# Text processing Language
	      	               		neovim		# Text Editor
	      	             		killall		# Stop Processes
		       			libarchive	# bsdtar : Utility to work with archives
	      	               ];
	      	       };

	      	       nix = {
	      	               # Enable Automatic Optimisation.
	      	               settings 	= {
	      	             	  auto-optimise-store 	= true;
	      	               };

	      	               # Enable Automatic Garbage Collection.
	      	               gc 		= {
	      	             	  automatic		= true;
	      	             	  dates			= "weekly";
	      	             	  options 		= "--delete-older-than 7d";
	      	               };

	      	               # Enable Exprimental Flakes, 
	      	               package 	= pkgs.nixFlakes;
	      	               extraOptions 	= ''
	      	       		keep-outputs 		= true
	      	       		keep-derivations	= true
	      	       		experimental-features 	= nix-command flakes #fix if enabled by default
	      	               '';
	      	       };

	      	       system = {
	      	               # Enable Automatic Upgrades.
	      	               autoUpgrade 	= {
	      	       		enable 	= true;
	      	       		allowReboot 	= false;
#	      	       		channel 	= "https://nixos.org/channels/nixos-unstable";
	      	               };
	      	               stateVersion 	= "21.11"; # Do not modify, before going through the manual.
	      	       };
 		      };
 		  }
 		  )

	      	  # User Specific home-manager Profile
 		  home-manager.nixosModules.home-manager {
 	      				    home-manager = {
	      					    useUserPackages	= true;
	      					    useGlobalPkgs	= true;
	      					    users		= {
	      						    ${USER} = {
#	      							    imports = [
#	      							      ./gui/${GUI}/home.nix #fix
#	      							      ./gui/${GUI}

#								      (  
#								      home = {
#									      username = "${USER}";
#									      homeDirectory = "/home/${USER}";
#								      }
#								      )
#								      ./gui/${GUI}/home.nix
#								    ];
	      							    imports = [
								      (  
								      {
 								        home = {
 								                username = "${USER}";
 								                homeDirectory = "/home/${USER}";
 								        };
								      }
 								      )
								      ] ++ [(import ./gui/${GUI}/home.nix)];
							    };
						    };
					    };
		  }
                ];
	};
    };
  };

}

