{ config, pkgs, ... }:

  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #			Boot Options
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  { 
  boot.initrd.kernelModules = [ "amdgpu" ];	

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-${config.globals.diskid}".device = "/dev/disk/by-uuid/${config.globals.diskid}";
}
