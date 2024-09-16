{ config, pkgs, ... }:

let
  feedhubPort = 6001;
in {
  systemd.services.feedhub = {
    enable = true;
    description = "Feedhub";

    wantedBy = [ "multi-user.target" ];

    environment = {
      ASPNETCORE_URLS = "http://localhost:${toString feedhubPort}";
    };

    # env is currently in .env file right beside project files
    serviceConfig = {
      Type = "simple";
      Restart = "always";
      StateDirectory = "feedhub";
      WorkingDirectory = "/var/lib/feedhub/bin";
      ExecStart = "${pkgs.dotnet-aspnetcore_8}/bin/dotnet ./Web.dll";
      RestartSec = 1;
    };
  };
}