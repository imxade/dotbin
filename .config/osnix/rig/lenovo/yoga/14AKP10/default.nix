{ inputs, lib, pkgs, config, ... }:
{

  /*
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
  */

  # SwapFile
  swapDevices = [{
    device = "/.swap";
    size = 25 * 1024;
  }];

  programs.gamemode.enable = true;
}
