{ config, pkgs, lib, ... }:

let 
  pocketbasePort = 8090;

  proxyHttp = 80;
  proxyHttps = 443;

  directory = ./services;
  servicesFilenames = builtins.attrNames (builtins.readDir directory);
  nixFiles = lib.filter (file: lib.hasSuffix ".nix" file) servicesFilenames;
  servicesImports = builtins.map (file: "${directory}/${file}") nixFiles;
in {
  imports = servicesImports;

  # http and https
  networking.firewall.allowedTCPPorts = [ proxyHttp proxyHttps ];
  # http/3
  networking.firewall.allowedUDPPorts = [ proxyHttps ];

  services.caddy = {
    enable = true;

    globalConfig = ''
      http_port ${toString proxyHttp}
      https_port ${toString proxyHttps}
    '';

    # needs to be moved to separate config file, because changes during runtime
    virtualHosts."cloud.cookingweb.dev" = {
      extraConfig = ''
        respond "Cooking Web self-hosted cloud is in a research stage. It runs on an old laptop with NixOS. At some point it will have UI. Checkout all info on cookingweb.dev or my X."
      '';
    };

    virtualHosts."pocketbase.cookingweb.dev" = {
      extraConfig = ''
        reverse_proxy :${toString pocketbasePort}
      '';
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
      ExecStart = "${pkgs.pocketbase}/bin/pocketbase serve --http='0.0.0.0:${toString pocketbasePort}' --dir='/var/lib/pocketbase'";
    };
  };
}