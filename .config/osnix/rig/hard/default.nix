{ lib, pkgs, config, nixpkgs, ... }:

{
  imports = [
    # Include Official Hardened Profile
    ./hardened.nix
  ];

  # enable firewall and block all ports
  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [ ];
      allowedUDPPorts = [ ];
    };
  };

  # disable coredump that could be exploited later
  # and also slow down the system when something crash
  systemd = { coredump = { enable = false; }; };

  # required to run chromium
  security = { chromiumSuidSandbox = { enable = true; }; };

  services = {
    # enable antivirus clamav and
    # keep the signatures' database updated
    clamav = {
      daemon = { enable = false; };
      updater = { enable = false; };
    };
    dbus = { apparmor = "enabled"; };
  };
}
