#!/bin/bash

SERVER="rk@192.168.50.10"

scp ./src/configuration.nix $SERVER:/tmp 
scp ./src/cloud.nix $SERVER:/tmp
scp ./src/services/pocketbase.nix $SERVER:/tmp
scp ./src/services/minecraft.nix $SERVER:/tmp

# sudo mv /tmp/minecraft.nix /etc/nixos/services/minecraft.nix
ssh -t $SERVER "
  sudo mv /tmp/cloud.nix /etc/nixos/cloud.nix
  sudo mv /tmp/configuration.nix /etc/nixos/configuration.nix
  sudo mv /tmp/pocketbase.nix /etc/nixos/services/pocketbase.nix
  sudo rm -f /etc/nixos/services/minecraft.nix
  sudo nixos-rebuild switch
"