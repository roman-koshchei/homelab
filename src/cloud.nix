{ config, pkgs, ... }:

{

  # http and https
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  # http/3
  networking.firewall.allowedUDPPorts = [ 443 ];

  services.caddy = {
    enable = true;

    globalConfig = ''
      http_port 80
      https_port 443
    '';

    # needs to be moved to separate config file, because changes during runtime
    extraConfig = ''
      cloud.cookingweb.dev {
        reverse_proxy :5000
      }
    '';
  };

  systemd.services.sharp-api-0 = {
    enable = true;
    description = "Sharp API";

    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      StateDirectory = "sharp-api";
      ExecStart = "${pkgs.dotnet-aspnetcore_8}/bin/dotnet /var/lib/sharp-api/bin/SharpApi.dll --urls 'http://0.0.0.0:5000'";
      WorkingDirectory = "/var/lib/sharp-api/bin";
    };

  };

  systemd.services.pocketbase-0 = {
    enable = true;
    description = "Pocketbase";

    wantedBy = [ "multi-user.target" "caddy.service" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      StateDirectory = "pb";
      ExecStart = "${pkgs.pocketbase}/bin/pocketbase serve --http='0.0.0.0:8091' --dir='/var/lib/pb'";
    };
  };

  
  systemd.services.pocketbase-1 = {
    enable = true;
    description = "Pocketbase 1";

    wantedBy = [ "multi-user.target" "caddy.service" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      StateDirectory = "pb";
      ExecStart = "${pkgs.pocketbase}/bin/pocketbase serve --http='0.0.0.0:8093' --dir='/var/lib/pb/'";
    };
  };

}