{ config, pkgs, ... }:

let
  port = 7888;
in {
  networking.firewall.allowedTCPPorts = [ port ]; 

  services.minecraft-server = {
    enable = true;                
    eula = true;           

    openFirewall = true;
    package = pkgs.papermc;       

    declarative = true;
    serverProperties = {
      server-port = port;
      online-mode = false;      
      gamemode = "survival";
      motd = "NixOS Minecraft Server";
    };
  };
}


