{
  description = "Have Some Flake";

  # Define All Flake references to be used for building NixOS setup. These are dependencies.
  inputs = rec {

    # set the channel
    nixpkgs = { url = "nixpkgs/nixos-unstable"; };

    # master channel for packages on the edge
    nixmaster = { url = "github:NixOS/nixpkgs"; };

    # hardware channel
    nixos-hardware = { url = "github:nixos/nixos-hardware"; };

    # enable home-manager
    home-manager = {
      url = "github:nix-community/home-manager/master";
      # tell home manager to use the nixpkgs channel set above.
      inputs = { nixpkgs = { follows = "nixpkgs"; }; };
    };
  };

  # Tell Flake what to use and what to do with the dependencies.
  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@inputs:

    # The following Variables are defined for the Ease of Modification.
    let
      # Modify 'Values' of 'Keys' inside value.toml, instead of Modifying Variables here
      # Read 'Keys' with their 'Values' from value.toml
      Toml = builtins.fromTOML (builtins.readFile ./value.toml);
      RIG = Toml.RIG; # Profile of machine to be used
      GUI = Toml.GUI; # Profile for Graphical Environment
      USER = Toml.USER; # Username
      ZONE = Toml.ZONE; # Set your time zone
      HOST = Toml.HOST; # Hostname of current system
      DISK = Toml.DISK; # Disk for Boot Loader
      RUID = Toml.RUID; # UUID of Root device, For Hibernate
      FUID = Toml.FUID; # UUID of Fat partition holding grub.cfg
      OFFSET = Toml.OFFSET; # Offset value of swapfile, For Hibernate
      TOR_BRIDGE = Toml.TOR_BRIDGE; # Bridge line for tor daemon
      system = Toml.system; # Platform Architecture
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        config = { allowUnfree = true; };
      };
      # Use Above Variables in ...
    in {
      formatter = { x86_64-linux = pkgs.nixfmt; };
      nixosConfigurations = {
        ${HOST} = lib.nixosSystem {
          inherit system pkgs;
          modules = [
            # If Path to File is specified, it will be imported
            # If Path to Directory is specified, 'default.nix' inside that will be imported

            # add model from this list: github.com/NixOS/nixos-hardware/blob/master/flake.nix
            #		    nixos-hardware.nixosModules.dell-xps-13-9380

            # Include the results of the hardware scan.
            #	      	    /etc/nixos/hardware-configuration.nix
            ./hardware-configuration.nix

            # Include Machine Profile
            # nixos-hardware.nixosModules.${RIG}
            ./${RIG}

            # Include GUI Profile
            ./${GUI}

            # Include Hardened Profile
            # ./rig/hard

            # Include Development Profile
            ./dev

            # configuration.nix : Universal System Configuration for all Profiles
            ({ lib, pkgs, config, system, nixpkgs, ... }: {
              fileSystems = {
                "/".options = [ "compress=zstd" "noatime" "space_cache=v2" ];
                "/home".options = [ "subvol=home" ];
              };
              boot = {
                # Hibernate Options
                kernelParams = [ "resume_offset=${OFFSET}" ];
                resumeDevice = "/dev/disk/by-uuid/${RUID}";

                # Configure boot loader
                loader = {
                  grub = {
                    enable = true;
                    efiSupport = true;
                    useOSProber = true;
                    enableCryptodisk = true;
                    efiInstallAsRemovable = true;
                    device = "${DISK}";
                    extraEntries = ''
                      menuentry "OTHER" {
                      search --set=root --fs-uuid ${FUID}
                      configfile /grub/grub.cfg }'';
                  };
                  efi = {
                    # Mount Point for Fat Partition
                    efiSysMountPoint = "/fat";
                  };
                  timeout = 2; # wait this much before auto-boot
                };
              };

              networking = {
                hostName = "${HOST}"; # Define your hostname.
                nameservers = [ "9.9.9.9" ];
                #			dhcpcd      = {
                #				enable = true;
                #				wait   = "background";
                #			};
                #	      	       	wireless = {
                #	      	       		enable = true;  # Enables wireless support via wpa_supplicant
                #				iwd = {
                #					enable = true; # use iwd for wireless support
                #				};
                #	      	       	};
                networkmanager = {
                  enable = true;
                  #				wifi = {
                  #					backend = "iwd"; # iwd instead of wpa_supplicant for wifi
                  #				};
                };
                #			resolvconf = { #fix disable openresolv
                #				package = {};
                #			};

                # The global useDHCP flag is deprecated, therefore explicitly set to false here.
                # Per-interface useDHCP will be mandatory in the future, so this generated config
                # replicates the default behaviour.
                useDHCP = false;
                interfaces = {
                  #	      	       		eth0 	  = {
                  #	      	       			useDHCP = true;
                  #	      	       		};
                  #	      	       		wlan0 	  = {
                  #	      	       			useDHCP = true;
                  #	      	       		};
                };

                # Configure network proxy if necessary
                #	      	       	proxy	   = {
                #	      	       		default = "http://user:password@proxy:port/";
                #	      	       		noProxy = "127.0.0.1,localhost,internal.domain";
                #	      	       	};
              };

              time = {
                timeZone = "${ZONE}"; # Set your time zone.
              };

              # Select internationalisation properties.
              i18n = { defaultLocale = "en_US.UTF-8"; };

              console = {
                font = "Lat2-Terminus16";
                keyMap = "us";
              };

              # System Fonts
              fonts.packages = [
                pkgs.nerd-fonts.hurmit
              ];


              # Define a user account.
              users = {
                users = {
                  ${USER} = {
                    #	      	       		  initialPassword	= "password";	# Password for the user
                    isNormalUser = true;
                    extraGroups = [
                      "seat"
                      "seatd"
                      "wheel"
                      "audio"
                      "video"
                      "input"
                      "camera"
                      "scanner"
                      "libvirt"
                      "docker"
                      "networkmanager"
                    ];
                    shell = pkgs.zsh; # Default shell
                  };
                };
              };

              programs = {
                zsh = { enable = true; };
                nix-ld = {
                  enable = true;
                  libraries = with pkgs;
                    [
                      # Add any missing dynamic libs for 
                      # unpackaged program here 
                    ];
                };
              };

              security = {
                unprivilegedUsernsClone = true; # For flatpak
                # sudo = {
                #   enable = false; # Disable sudo
                # };
                rtkit = { enable = true; };
              };

              # Configure SystemWide services
              services = {
                getty = { autologinUser = "${USER}"; };

                # dbus = {
                #   #				 enable = lib.mkForce false;
                #   apparmor = "enabled";
                # };

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

                # Enable the OpenSSH daemon.
                openssh = {
                  enable = false;
                  allowSFTP = true;
                  extraConfig = "  HostKeyAlgorithms +ssh-rsa\n";
                };

                # Enable Flatpak
                flatpak = { enable = true; };

                # Enable Tor proxy
                tor = {
                  enable = true;
                  client = {
                    enable = true;
                    socksListenAddress = {
                      IsolateDestAddr = true;
                      addr = "127.0.0.1"; # Socks Host
                      port = 9050; # Port
                    };
                  };
                  settings = {
                    #       			 	SOCKSPort = [
                    #       			 	    {
                    #       			 	         port = 9090;
                    #       			 	    }
                    #       			 	  ];
                    #				 	Bridge = "obfs4 IP:ORPort [fingerprint]";
                    UseBridges = true;
                    Bridge = "${TOR_BRIDGE}";
                    ClientTransportPlugin =
                      "obfs4 exec ${pkgs.obfs4}/bin/obfs4proxy";
                  };
                };
              };

              xdg = {
                portal = {
                  enable = true; # Required by flatpak
                  xdgOpenUsePortal = true;

                };
              };

              environment = {
                # Define Environment System Wide variables
                variables = {
                  # fixes libstdc++ issues and libgl.so issues
                  LD_LIBRARY_PATH="${pkgs.stdenv.cc.cc.lib}/lib/:/run/opengl-driver/lib/";
                  # fixes xcb issues :
                  QT_PLUGIN_PATH="${pkgs.qt5.qtbase}/${pkgs.qt5.qtbase.qtPluginPrefix}";
                };

                # List packages installed in system profile.
                defaultPackages = [ ]; # Do not install anything by default
                systemPackages = with pkgs; [
                  git # To take Care of Git repositories
                  gawk # Text processing Language
                  neovim # Text Editor
                  libarchive # bsdtar : Utility to work with archives
                ];

                # Create file /etc/current-system-packages with List of all Packages
                etc = {
                  "current-system-packages" = {
                    text = let
                      packages = builtins.map (p: "${p.name}")
                        config.environment.systemPackages;
                      sortedUnique =
                        builtins.sort builtins.lessThan (lib.unique packages);
                      formatted = builtins.concatStringsSep "\n" sortedUnique;
                    in formatted;
                  };
                };
              };

              #			environment.etc."current-system-packages".text =
              #			let
              #			packages = builtins.map (p: "${p.name}") config.environment.systemPackages;
              #			sortedUnique = builtins.sort builtins.lessThan (lib.unique packages);
              #			formatted = builtins.concatStringsSep "\n" sortedUnique;
              #			in
              #			formatted;

              nix = {
                # Enable Automatic Optimisation.
                settings = { auto-optimise-store = true; };

                # Enable Automatic Garbage Collection.
                gc = {
                  automatic = true;
                  dates = "weekly";
                  options = "--delete-older-than +10";
                  # options = "--delete-older-than 7d";
                };

                # Enable Exprimental Flakes, 
                package = pkgs.nixVersions.stable;
                extraOptions =
                  "		keep-outputs 		= true\n		keep-derivations	= true\n		experimental-features 	= nix-command flakes #fix if enabled by default\n        ";
              };

              system = {
                # Enable Automatic Upgrades.
                autoUpgrade = {
                  enable = true;
                  allowReboot = false;
                  # channel = "https://nixos.org/channels/nixos-unstable";
                  flake = inputs.self.outPath;
                  flags = [
                    "--update-input"
                    "nixpkgs"
                    "-L" # print build logs
                  ];
                  dates = "02:00";
                  randomizedDelaySec = "45min";
                };
                stateVersion = "21.11"; # Do not modify
              };
            })

            # User Specific home-manager Profile
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useUserPackages = true;
                useGlobalPkgs = true;
                users = {
                  ${USER} = { lib, pkgs, config, system, nixpkgs, ... }: {
                    imports = [({
                      home = {
                        username = "${USER}";
                        homeDirectory = "/home/${USER}";
                        stateVersion = "21.11"; # Do not modify
                      };
                    })] ++ [ (import ./${GUI}/home.nix) ];
                  };
                };
              };
            }
          ];
        };
      };
    };
}
