# remove-bloat.nix
{ config, pkgs, ... }:

  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #			Remove the Bloat
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
{
  # Remove the Bloat
  environment.gnome.excludePackages = with pkgs; [
    baobab
    cheese
    cups
    decibels
    eog
    epiphany
    evince
    firefox
    gedit
    papers
    simple-scan
    snapshot
    totem
    showtime
    yelp
    file-roller
    geary
    seahorse
    nixos-render-docs
    xterm

    gnome-calculator
    gnome-calendar
    gnome-console
    gnome-characters
    gnome-clocks
    gnome-contacts
    gnome-font-viewer
    gnome-logs
    gnome-maps
    gnome-music
    gnome-photos
    gnome-screenshot
    gnome-system-monitor
    gnome-tour
    gnome-text-editor
    gnome-weather
    #gnome-disk-utility
    gnome-connections
  ];

  # Disable xterm
  services.xserver.excludePackages = [ pkgs.xterm ];
  services.xserver.desktopManager.xterm.enable = false;

  # Disable the manual
  documentation.nixos.enable = false;
}
