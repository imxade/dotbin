{ config, pkgs, lib, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/profiles/hardened.nix"
  ];

  security = {
    lockKernelModules = lib.mkForce true;
    allowSimultaneousMultithreading = lib.mkForce false;
  };

  boot.blacklistedKernelModules = [
    "ax25"
    "netrom"
    "rose"
  ];
}
