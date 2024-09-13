{ config, pkgs, ... }:

let 
  cloudPort = 5000;
  pocketbasePort = 8090;

  proxyHttp = 80;
  proxyHttps = 443;
in {
  # http and https
  networking.firewall.allowedTCPPorts = [ proxyHttp proxyHttps ];
  # http/3
  networking.firewall.allowedUDPPorts = [ proxyHttps ];

  services.caddy = {
    enable = true;

    globalConfig = ''
      http_port ${proxyHttp}
      https_port ${proxyHttps}
    '';

    # needs to be moved to separate config file, because changes during runtime
    virtualHosts."cloud.cookingweb.dev" = {
      extraConfig = ''
        reverse_proxy :${cloudPort}
      '';
    };

    virtualHosts."pocketbase.cookingweb.dev" = {
      extraConfig = ''
        reverse_proxy :${pocketbasePort}
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
      ExecStart = "${pkgs.dotnet-aspnetcore_8}/bin/dotnet /var/lib/sharp-api/bin/SharpApi.dll --urls 'http://0.0.0.0:${cloudPort}'";
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
      ExecStart = "${pkgs.pocketbase}/bin/pocketbase serve --http='0.0.0.0:${pocketbasePort}' --dir='/var/lib/pocketbase'";
    };
  };

}