# machines

Setup kits for my machines: how each one is created or rebuilt and brought to a known state, with the docs next to the code. Cloud
servers with Ansible, and NixOS machines.

| Folder | What |
|---|---|
| [`hetzner/`](hetzner/README.md) | Hetzner Cloud servers: a rebuild with cloud-init, then Ansible (the Cloud Firewall, a hardened base, small tools, and a development toolbox added one role at a time) |
| [`nixos/`](nixos/README.md) | NixOS machines. For now, my 2019 laptop config (NixOS 19.03), imported with its history; it needs updating before it runs again |

**Later:** `docs/` (server and hosting tutorials), when its first file is written.

## The rules

- **Machine setup only.** App deployment lives with the apps, not here.
- **Public-safe only:** no secrets, no server names, no addresses, no account details. Each kit keeps those in a local file that git
  ignores (for example `hetzner/inventory.yml`).
- **One folder per kit or topic,** each with its own README. The table above is the index.
- **Each kit runs from its own folder.** For Ansible, that means `cd hetzner` first, so it reads that folder's `ansible.cfg`.
