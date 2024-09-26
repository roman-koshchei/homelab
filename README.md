# HomeLab

Building cloud on own old laptop to create cloud boxes later.

## Running services

I need to run services to get production-like environment,
so I run some of my own apps on it:

- Pocketbase instance, see [pocketbase.nix](./src/services/pocketbase.nix)
- Feedhub web app, see [feedhub.nix and deploy.sh in feedhub repo](https://github.com/roman-koshchei/feedhub)
- Uptime Kuma

Feedhub deployment files are moved to feedhub repository,
because that's how you would use it anyway.
Keeping deploy configuration right inside of the project.

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

I use [Caddy](https://caddyserver.com) for revere proxy.

## Resources

- [The cloud is over-engineered and overpriced](https://www.youtube.com/watch?v=jFrGhodqC08)
- [Setting up a production ready VPS is a lot easier than I thought](https://www.youtube.com/watch?v=F-9KWQByeU0)

- [Linux Filesystem, where to place files](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)
- [IIS ARR Zero Downtime](https://github.com/yosoyadri/IIS-ARR-Zero-Downtime)
- [Zero Downtime Deployments on IIS](https://kevinareed.com/2015/11/07/how-to-deploy-anything-in-iis-with-zero-downtime-on-a-single-server/)

### Homelabs

List of resource of other people showing their homelabs and network setups.
I will need to change my network setup, because now it seems like one of the biggest bottlenecks for speed.

- [arslan.io/2024/09/10/my-homelab-setup](https://arslan.io/2024/09/10/my-homelab-setup)
- [Fixing my AWFUL Home Networking!](https://www.youtube.com/watch?v=qQx70PuLYI0)

### Nix

List of resource connected to Nix and NixOS.

- [Cube's NixOS](https://github.com/RGBCube/NCC)
- [Cab language (nix from Cube)](https://github.com/cull-os/cab)
