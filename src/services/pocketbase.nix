{ config, pkgs, lib, ... }:

let
  port = 8090;
  id = "pocketbase";
  stateDir = "pocketbase";
in {
  systemd.services.${id} = {
    enable = true;
    description = "Pocketbase";

    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      StateDirectory = stateDir;
      ExecStart = "${pkgs.pocketbase}/bin/pocketbase serve --http='localhost:${toString port}' --dir='/var/lib/${stateDir}'";
    };
  };

  # lib.mkOrder (if reload then 50 else 100) 
  services.caddy.virtualHosts."pocketbase.cookingweb.dev".extraConfig =''
    reverse_proxy :${toString port}
  '';
}