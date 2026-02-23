{ config, pkgs, ... }:

{
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #				Programs
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
     # Gnome Extensions
     gnomeExtensions.blur-my-shell
     gnomeExtensions.vitals

     # Terminal
     alacritty

     # Browser
     librewolf
     tor-browser

     # System Monitor
     btop
     tree
     fastfetch

     # Note Taking
     obsidian

     # PDF viewer
     zathura
     texliveFull
     biber

     # Music
     cmus
     cava

     # Imager
     rpi-imager

     # Electronics
     ngspice
     kicad

     # Sysadmin
     ansible
     dbeaver-bin
     talosctl
     mosquitto

     # Video
     yt-dlp

     # Password manager
     keepassxc

     # Programming
     git
     
     # WOL
     wakeonlan

     # Site Generator
     hugo
     
     # Virtualization
     virt-manager
     qemu_kvm
     virtualbox
     gtk3 
     glibc

     # Presentations
     marp-cli
  ];
  # Steam
  programs.steam.enable = true;
  # Virtual Box
  #virtualisation.virtualbox.host.enable = true;
  #users.extraGroups.vboxusers.members = [ "gabriel" ];

}
