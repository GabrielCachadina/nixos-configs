# remove-bloat.nix
{ config, pkgs, ... }:

  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
  #				Newsboat
  #-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-.-
let
  newsboatConf = pkgs.writeText "config" ''
    auto-reload yes
    max-items 100


    # -- Theme ----------------------------------------------------------------

    color listnormal default default
    color listfocus default default reverse
    color listnormal_unread default default bold
    color listfocus_unread default default bold underline
    color info red black bold
    color article default default

    highlight article "^Feed:.*" magenta default
    highlight article "^Title:.*" yellow default bold
    highlight article "^Author:.*" green default
    highlight article "^Date:.*" color223 default
    highlight article "^Link:.*" blue default
    highlight article "^Flags:.*" color9 default
    highlight article "\\[[0-9][0-9]*\\]" color66 default bold
    highlight article "\\[image [0-9][0-9]*\\]" color109 default bold
    highlight article "\\[embedded flash: [0-9][0-9]*\\]" color66 default bold

    #highlight feedlist "[╒╘╞]═.*═[╛╕╡]" yellow default bold
    highlight feedlist "[║│]" yellow default bold
    highlight feedlist "╠═.*" yellow default bold

    highlight feedlist "\\(Youtube\\) .*" red
    highlight feedlist "\\(Twitter\\) .*" blue
    highlight feedlist "\\(Reddit\\) .*" green
    highlight feedlist "\\(Podcast\\) .*" yellow
    highlight feedlist "\\(Twitch\\) .*" magenta
    highlight feedlist "\\(Blog\\) .*" cyan
    #highlight feedlist "\\(Reddit\\) .*" color166


    feedlist-format "%?T?║%4i %n %8u (%T) %t &╠═════════════════════════════════════════════════════%t?"
    #feedlist-format "%?T?║%4i %n %8u (%T) %t &╠%=═0%t?"
    #feedlist-format "%?T?║%4i %n %8u (%T) %t &%==11first%=x16SECOND%=~13third?"

    # -- navigation ----------------------------------------------------------------

    # unbind keys
    unbind-key ENTER
    unbind-key j
    unbind-key k
    unbind-key J
    unbind-key K
    unbind-key l

    # bind keys - vim style
    bind-key j down
    bind-key k up
    bind-key l open
    bind-key h quit

    # -- misc ----------------------------------------------------------------------

    macro w set browser "librewolf %u"; open-in-browser ; set browser "librewolf %u"
    macro v set browser "setsid -f mpv --really-quiet --no-terminal" ; open-in-browser ; set browser librewolf


    # -- WIP ----------------------------------------------------------------------
    #macro y set browser "setsid -f mpv '/home/${config.globals.username}/Videos/Youtube/Jeff Geerling/%T.mkv'"; open-in-browser ; set browser librewolf
  '';
  newsboatUrls = pkgs.writeText "urls" ''
    Blogs
    https://gabrielcachadina.com/index.xml Blog "~Gabriel Cachadiña" Tech
    https://www.jeffgeerling.com/blog.xml Blog "~Jeff Geerling" Tech
    http://lukesmith.xyz/rss.xml Blog "~Luke Smith" Tech
    Youtube
    https://www.youtube.com/feeds/videos.xml?playlist_id=UULFmu9PVIZBk-ZCi-Sk2F2utA Youtube "~3kliksphilip"
    https://www.youtube.com/feeds/videos.xml?playlist_id=UULFk2KE7yg0BwsJfr8Dp9ivUQ Youtube "~AsumSaus"
    https://www.youtube.com/feeds/videos.xml?playlist_id=UULFkcnYVAVZQOB-nXHechtXDg Youtube "~Benjamin"
    https://www.youtube.com/feeds/videos.xml?playlist_id=UULFsBjURrPoezykLs9EqgamOA Youtube "~Fireship"
    https://www.youtube.com/feeds/videos.xml?playlist_id=UULFR-DXc1voovS8nhAvccRZhg Youtube "~Jeff Geerling"
    https://www.youtube.com/feeds/videos.xml?playlist_id=UULF7YOGHUfC1Tb6E4pudI9STA Youtube "~Mental Outlaw"
    https://www.youtube.com/feeds/videos.xml?playlist_id=UULFV6luCxsKUK2Ld-Zav-pGeg Youtube "~MRswipez1"
    https://www.youtube.com/feeds/videos.xml?playlist_id=UULF2eYFnH61tmytImy1mTYvhA Youtube "~Luke Smith" Tech
    https://www.youtube.com/feeds/videos.xml?playlist_id=UULFN5xN8gIljvWYnsj06V8WbQ Youtube "~Pyrocynical"
    https://www.youtube.com/feeds/videos.xml?playlist_id=UULFW6xlqxSY3gGur4PkGPEUeA Youtube "~Seytonic"
    https://www.youtube.com/feeds/videos.xml?playlist_id=UULFJy232tY_LUd1NuBgsSNUEA Youtube "~SirSwag"
    https://www.youtube.com/feeds/videos.xml?playlist_id=UULFD6VugMZKRhSyzWEWA9W2fg Youtube "~SsethTzeentach"
    https://www.youtube.com/feeds/videos.xml?channel_id=UCERpgysn81hv0c0FXIjXsTg Youtube "~TobiasFate"
    https://www.youtube.com/feeds/videos.xml?playlist_id=UULF6nSFpj9HTCZ5t-N3Rm3-HA Youtube "~Vsauce"
    https://www.youtube.com/feeds/videos.xml?playlist_id=UULF3cpN6gcJQqcCM6mxRUo_dA Youtube "~Wendigoon"
    Twitch
    https://twitchrss.com/feeds/?username=riotgames&feed=streams Twitch "~RiotGames"
    Podcast
    Reddit
  '';
in
{

  environment.systemPackages = with pkgs; [
     newsboat
  ];

  # DotFiles
  systemd.tmpfiles.rules = [
    "d /home/${config.globals.username}/.config/newsboat 0755 ${config.globals.username} users -"
    "r /home/${config.globals.username}/.config/newsboat/config"
    "r /home/${config.globals.username}/.config/newsboat/urls"
    "L+ /home/${config.globals.username}/.config/newsboat/config - - - - ${newsboatConf}"
    "L+ /home/${config.globals.username}/.config/newsboat/urls - - - - ${newsboatUrls}"
  ];

}
