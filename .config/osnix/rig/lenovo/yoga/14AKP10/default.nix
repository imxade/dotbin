{ inputs, lib, pkgs, config, ... }:
{
  hardware = {
    amdgpu.overdrive.enable = true;
    enableRedistributableFirmware = true;
    sensor.iio.enable = true;  # Enables iio-sensor-proxy
  };

  /*
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
