# HomeLab

Building cloud on own old laptop to create cloud boxes later.

## Router

To make web server accessible from public internet we need to forward ports from router to a machine that runs server.

First of all set local static IP address for your machine, like `192.168.31.10` in my case.
So the local IP address of machine never changes.

Then from router control panel in some section called "Port forwarding" or similar forward ports to the machine you have set local static IP addresses.

| Protocol | Router port | Machine port |
| -------- | ----------- | ------------ |
| TCP      | 80          | 80           |
| TCP      | 443         | 443          |
| UDP      | 443         | 443          |

You can forward to any machine port, like 8080 or 8443 if you like. But it will be easier to think about it if they will be the same.

## OS

I am exploring NixOS right now for server machine, it seems interesting.
I separated cloud related configuration in [cloud.nix](./nixos/cloud.nix) file.

NixOS is immutable distribution that is configured with Nix language.

Configuration file is located at `/etc/nixos`, to rebuild current system run:

```bash
sudo nixos-rebuild switch
```

Currently `configuration.nix` also contains some configuration for desktop environment, because it's easier to operate during learning period. In future it will be replaced with headless configuration.

### Todo

- setup automatic deletion of old versions of system (> 14 days old)

## Software

