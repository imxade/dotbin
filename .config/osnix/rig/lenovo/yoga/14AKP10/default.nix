{ inputs, lib, pkgs, config, ... }:
{

  environment.systemPackages = with pkgs; [
    squeekboard
  ];
  hardware = {
    amdgpu.overdrive.enable = true;
    enableRedistributableFirmware = true;
  };

  boot = {
    kernelModules = [ "btusb" ];
  };
  programs.gamemode.enable = true;
}
