{ inputs, lib, pkgs, config, ... }:
{

  hardware = {
    amdgpu.overdrive.enable = true;
    enableRedistributableFirmware = true;
  };

  boot = {
    kernelModules = [ "btusb" ];
  };

}
