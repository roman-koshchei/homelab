#!/bin/bash

SERVER="rk@192.168.31.10"

scp ./src/configuration.nix $SERVER:/tmp 
scp ./src/cloud.nix $SERVER:/tmp
scp ./src/services/feedhub.nix $SERVER:/tmp

ssh -t $SERVER "
  sudo mv /tmp/cloud.nix /etc/nixos/cloud.nix
  sudo mv /tmp/configuration.nix /etc/nixos/configuration.nix
  sudo mv /tmp/feedhub.nix /etc/nixos/services/feedhub.nix
  sudo nixos-rebuild switch
"