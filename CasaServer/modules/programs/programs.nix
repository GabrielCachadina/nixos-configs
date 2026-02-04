{ config, pkgs, ... }:

{
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #				Programs
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
     # System Monitor
     btop
     nvtopPackages.amd
     tree
     fastfetch

     # Programming
     git
	
     # Wireguard tools
     wireguard-tools
  ];
}
