{
  description = "Have Some Flake";

  inputs = {
    # Main package/channel
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Declarative Flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    # Hardware-specific modules
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # Disk partitioning / installation
    disko.url = "github:nix-community/disko";

    /*
    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    */
  };

  outputs = { self, nixpkgs, disko, ... }@inputs: {

    nixosConfigurations = {

      # ======================================================
      # PERSONAL MACHINE
      # ======================================================

      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./configuration.nix
          ./hardware-configuration.nix
        ];
      };


      # ======================================================
      # ORACLE CLOUD AMPERE A1 - ALWAYS FREE PROFILE
      #
      # Target:
      #   VM.Standard.A1.Flex
      #   aarch64-linux
      #
      # Filesystem:
      #   GPT
      #   EFI
      #   Btrfs
      #   root/home/nix subvolumes
      #
      # x86_64:
      #   transparent userspace emulation via binfmt/QEMU
      # ======================================================

      oracle-free = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";

        specialArgs = {
          inherit inputs;
        };

        modules = [
          disko.nixosModules.disko

          ./oracle/free.nix
        ];
      };


      # ======================================================
      # ISO
      # ======================================================

      iso = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        specialArgs = {
          inherit inputs;
        };

        modules = [
          ./iso.nix
          ./configuration.nix
        ];
      };
    };
  };
}