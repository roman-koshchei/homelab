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
    virtualHosts."cloud.cookingweb.dev" = {
      extraConfig = ''
        reverse_proxy :5000
      '';
    };

    virtualHosts."pocketbase.cookingweb.dev" = {
      extraConfig = ''
        reverse_proxy :8090
      '';
    };
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

  systemd.services.pocketbase = {
    enable = true;
    description = "Pocketbase";

    wantedBy = [ "multi-user.target" ];

    serviceConfig = {
      Type = "simple";
      Restart = "always";
      StateDirectory = "pocketbase";
      ExecStart = "${pkgs.pocketbase}/bin/pocketbase serve --http='0.0.0.0:8090' --dir='/var/lib/pocketbase'";
    };
  };

}