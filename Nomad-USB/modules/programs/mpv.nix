{ config, pkgs, ... }:

let
  mpvConf = pkgs.writeText "mpv.conf" ''
    #######################################################################################################################################
    # Tweaks/UI

    fullscreen
    no-osd-bar
    osd-font-size = 32
    keep-open = yes
    volume = 100
    volume-max = 100

    #######################################################################################################################################
    # Subtitles

    #slang = por,eng #Change to your preferred languages
    sub-auto = fuzzy #Allow loading external subs that do not match file name perfectly.

    sub-ass-override=no
    sub-font = 'Inter Medium' 
    sub-bold = no
    sub-font-size = 56
    sub-outline-size = 2.7
  '';
in
{
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #				MPV
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  environment.systemPackages = with pkgs; [
     mpv
  ];
  
  # DotFiles
  systemd.tmpfiles.rules = [
    "d /home/${config.globals.username}/.config/mpv 0755 ${config.globals.username} users -"
    "r /home/${config.globals.username}/.config/mpv/mpv.conf"
    "L+ /home/${config.globals.username}/.config/mpv/mpv.conf - - - - ${mpvConf}"
  ];

}
