{
  description = "Have Some Flake";

  # Define All Flake references to be used for building NixOS setup. These are dependencies.
  inputs = rec {
    # determinate nix
    determinate.url = "https://flakehub.com/f/DeterminateSystems/determinate/*";

    # set the pkgs channel
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Declaratve flatpak
    nix-flatpak.url = "github:gmodena/nix-flatpak/?ref=latest";

    # hardware channel
    nixos-hardware.url = "github:nixos/nixos-hardware";

    # enable home-manager
    home-manager = {
      url = "github:nix-community/home-manager";
      # tell home manager to use the nixpkgs channel set above.
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # Tell Flake what to use and what to do with the dependencies.
  outputs = { self, nixpkgs, determinate ... }@inputs: {
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
        };
        modules = [
          ./configuration.nix
          determinate.nixosModules.default
        ];
      };
    };
  };
}
