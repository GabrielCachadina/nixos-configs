{ config, pkgs, ... }:


let
  dashyConfig = pkgs.writeText "dashy-config.yml" ''
appConfig:
  theme: one-dark
  layout: horizontal
  iconSize: medium
  language: en

  hideHeading: true
  hideNav: true
  hideSearch: true
  hideSettings: true
  hideFooter: true
  disableConfiguration: true


pageInfo:
  title: Dashboard
  description: Blessed is the mind too small for doubt.

sections:
  - name: Search
    widgets:
      - type: custom-search
        options:
          placeholder: Search for something using the buttons below
          openingMethod: newtab
          engines:
            - title: SearXNG
              url: https://searxng.gabrielcachadina.com/search?q=
            - title: Youtube
              url: https://www.youtube.com/results?search_query=
            - title: Nixpkgs
              url: https://search.nixos.org/packages?channel=25.11&query=
            - title: Wikipedia
              url: https://en.wikipedia.org/w/index.php?search=

  - name: Casa-Server
    items:
      - title: Jellyfin
        icon: si-jellyfin
        url: http://192.168.0.16:8096/web/
        statusCheck: true
      - title: Grafana
        icon: si-grafana
        url: http://192.168.0.16:3000
        statusCheck: true
      - title: Kavita
        icon: si-gitbook
        url: http://192.168.0.16:5000
        statusCheck: true
      - title: PiHole
        icon: si-pihole
        url: http://192.168.0.16/admin/login
        statusCheck: true
      - title: Qbittorrent
        icon: si-qbittorrent
        url: http://192.168.0.16:8080
        statusCheck: true
      - title: Audiobookshelf
        icon: si-audiobookshelf
        url: http://192.168.0.16:13378
        statusCheck: true
      - title: PiHole
        icon: si-pihole
        url: http://192.168.0.16:80/admin
        statusCheck: true
      - title: Lidarr
        icon: si-applemusic
        url: http://192.168.0.16:8686
        statusCheck: true
      - title: Radarr
        icon: si-radarr
        url: http://192.168.0.16:7878
        statusCheck: true
      - title: Prowlarr
        icon: si-podcastindex
        url: http://192.168.0.16:9696
        statusCheck: true
      - title: Sonarr
        icon: si-sonarr
        url: http://192.168.0.16:8989
        statusCheck: true
      - title: Syncthing
        icon: si-syncthing
        url: http://192.168.0.16:8384
        statusCheck: true
  - name: Linode
    items:
      - title: Website
        icon: si-hugo
        url: https://gabrielcachadina.com
        statusCheck: true
      - title: Calendar
        icon: si-protoncalendar
        url: https://calendario.gabrielcachadina.com
        statusCheck: true
      - title: Excalidraw
        icon: si-excalidraw
        url: https://excalidraw.gabrielcachadina.com
        statusCheck: true
      - title: Grafana
        icon: si-grafana
        url: https://grafana.gabrielcachadina.com
        statusCheck: true
  - name: Server-Main
    items:
      - title: Gitea
        icon: si-gitea
        url: https://gitea.gabrielcachadina.com
        statusCheck: true
      - title: Syncthing
        icon: si-syncthing
        url: https://syncthing.gabrielcachadina.com
        statusCheck: true
  - name: Useful Websites
    items:
      - title: Subdomain Finder
        url: https://subdomainfinder.c99.nl/
      - title: PVGIS
        url: https://pvgis.com/es
      - title: RAE
        url: https://dle.rae.es/
  '';
in
{
  virtualisation.docker.enable = true;
  virtualisation.oci-containers = {
    backend = "docker";
    containers.dashy = {
      image = "lissy93/dashy";
      environment = {
        NODE_ENV = "production";
        UID = "1000";
        GID = "1000";
      };
      volumes = [
        "${dashyConfig}:/app/user-data/conf.yml"
      ];
      ports = [
        "9000:8080"
      ];
      autoStart = true;
    };
  };
}
