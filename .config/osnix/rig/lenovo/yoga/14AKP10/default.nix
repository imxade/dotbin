{ inputs, lib, pkgs, config, ... }:
{
  hardware = {
    amdgpu.overdrive.enable = true;
    enableRedistributableFirmware = true;
    sensor.iio.enable = true;  # Enables iio-sensor-proxy
  };

  networking.networkmanager = {
    wifi.powersave = false;  # Disable powersave (3=auto default)
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
