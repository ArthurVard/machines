# nixos: NixOS machines

Part of [machines](../README.md). For now it holds one config: my 2019 laptop (a Dell), imported with its history from
[ArthurVard/nixos-config](https://github.com/ArthurVard/nixos-config) (12 commits, May to September 2019).

**It doesn't build on today's NixOS as it is.** It was written for NixOS 19.03, before flakes. Update it before installing it on a
machine again: see "Before it runs again" below.

## What's in it

| File | What |
|---|---|
| `configuration.nix` | the machine: boot (systemd-boot, LUKS on NVMe), Wi-Fi, sound, graphics, firmware, the firewall, Nix's settings; it imports the modules below. `hardware-configuration.nix`, generated on the machine, isn't in git |
| `simple_configuration.nix` | a minimal config (boot, LUKS, SSH, a few tools), kept from the first install |
| `nix-configs/users.nix` | the user `arthur`, and sudo for `nixos-rebuild switch` |
| `nix-configs/xserver.nix`, `fonts.nix` | X with LightDM, KDE Plasma 5, i3 (i3-gaps) and xmonad; the touchpad; keyboard layouts us, ru, am; fonts |
| `nix-configs/applications/` | the apps, one module per group: editors and desktop apps, dev tools (Coq, OCaml, Haskell, Nix), Docker, VirtualBox, databases, terminals, tmux, KeePass, screen recording and streaming, network tools |
| `nix-configs/syncthing.nix` | Syncthing for the user |
| `nix-configs/private-ssh-pipe.nix` | a custom module that passes the user's SSH agent to the Nix daemon (to drop: see below) |
| `nix-configs/hoogle.nix`, `xmonad.nix`, `applications/network.nix` | not imported by anything: a local Hoogle with a set of Haskell packages, an xmonad setup, NetworkManager's tools |

## Before it runs again

1. **Update it to the current NixOS, as a flake.** About a dozen options were renamed or removed since 19.03. Examples:
   - the LUKS device list (now an attribute set);
   - `nix.binaryCaches` and its siblings (now under `nix.settings`);
   - `hardware.opengl` (now `hardware.graphics`);
   - `sound.enable` and PulseAudio (PipeWire is the usual choice now);
   - users now need `isNormalUser`;
   - the `hydra.iohk.io` cache (now `cache.iog.io`).
2. **Drop `private-ssh-pipe`.** It lets every Nix build use the user's SSH agent, with host-key checking off. Flakes fetch as the
   user, so it's no longer needed.
3. **Check the passwordless `sudo nixos-rebuild switch`.** It's fine while `/etc/nixos` belongs to root. If `/etc/nixos` links to a
   folder the user can edit, it gives root without a password.
4. **SSH with keys only.** Port 22 is open, with 2019's defaults, which allowed passwords.
5. **One boot loader.** systemd-boot is on, and grub lines are left over.
6. **Wi-Fi with NetworkManager alone,** instead of wpa_supplicant next to NetworkManager's tools.
