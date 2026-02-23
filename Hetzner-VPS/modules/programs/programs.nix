{ config, pkgs, ... }:

{
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #				Programs
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
     # Text Editor
     neovim

     # System Monitor
     btop
     nvtopPackages.amd
     tree
     fastfetch

     # Programming
     git
	
  ];
}
