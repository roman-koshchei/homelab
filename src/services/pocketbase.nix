{ config, pkgs, lib, ... }:

let
  port = 8090;
  stateDir = "pocketbase";
in {
  systemd.services.pocketbase = {
    enable = true;
    description = "Pocketbase";

    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      StateDirectory = stateDir;
      ExecStart = "${pkgs.pocketbase}/bin/pocketbase serve --http='0.0.0.0:${toString port}' --dir='/var/lib/${stateDir}'";
    };
  };

  services.caddy.virtualHosts."pocketbase.cookingweb.dev".extraConfig = ''
    reverse_proxy :${toString port}
  '';
}