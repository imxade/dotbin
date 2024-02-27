{ lib, pkgs, config, ... }:

{

  virtualisation = {
    docker = {
      enable = true;
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    libvirtd = {
      enable = true;
      qemu = {
        ovmf = { enable = true; };
        swtpm = { enable = false; };
      };
    };
  };
}

