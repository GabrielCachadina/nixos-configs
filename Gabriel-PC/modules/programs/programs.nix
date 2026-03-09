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
     gnomeExtensions.caffeine

     # Terminal
     alacritty
     tmux

     # Browser
     librewolf
     tor-browser

     # System Monitor
     btop
     nvtopPackages.amd
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

     # Email
     thunderbird

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
     pciutils
     usbutils
     openssl

     # Video
     yt-dlp

     # Password manager
     keepassxc

     # Programming
     git
     python3 
     libusb1

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

     # VPN
     wireguard-tools

     # Games
     prismlauncher

     # Presentations
     marp-cli

     # Office
     libreoffice-qt-fresh
     
     # XMPP
     dino
     xmppc
  ];
  # Steam
  programs.steam.enable = true;
  # Virtual Box
  #virtualisation.virtualbox.host.enable = true;
  #users.extraGroups.vboxusers.members = [ "gabriel" ];
  programs.nix-ld.enable = true; # Compatibility layer for NixOS that allows it to run precompiled, dynamically linked Linux binaries
}
