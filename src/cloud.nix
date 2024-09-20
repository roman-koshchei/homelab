{ config, pkgs, lib, ... }:

let 
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
        reverse_proxy :3001
      '';
      # extraConfig = ''
      #   respond "Cooking Web self-hosted cloud is in a research stage. It runs on an old laptop with NixOS. At some point it will have UI. Checkout all info on cookingweb.dev or my X."
      # '';
    };
  };

  services.uptime-kuma = {
    enable = true;
    settings = {
      PORT = "3001";
    };
  };
}