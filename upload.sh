scp ./src/cloud.nix rk@192.168.31.10:/tmp

ssh -t rk@192.168.31.10 "sudo mv /tmp/cloud.nix /etc/nixos/cloud.nix; sudo nixos-rebuild switch"