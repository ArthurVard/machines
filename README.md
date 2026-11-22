# hetzner-servers

Set up Hetzner Cloud servers with cloud-init and Ansible, any time: rebuild a server from scratch (soon also create a new one), then
bring it to a known state. Every server gets a hardened base (SSH keys only, a firewall in front, fail2ban, Docker) and a few small
tools. A development server also gets a toolbox of languages, added one role at a time.

**Server setup only:** no apps and no deployment live here.

- **`rebuild.yml` wipes a server's disk.** Run it by hand, for one server at a time.
- **`site.yml` is safe to re-run.** A second run should report `changed=0`.
- **No secrets, no server names and no addresses live in this repo.** Your servers are listed in your own `inventory.yml`, which git
  ignores. The Hetzner API token comes from your shell.

## Files

| File | What |
|---|---|
| `inventory.example.yml` | the shape of your `inventory.yml`: copy it and fill it in |
| `group_vars/all.yml` | every server: the Ubuntu image, the login user, the SSH keys, the firewall |
| `group_vars/servers.yml` | how Ansible connects: the user and the one key |
| `group_vars/toolbox.yml` | the development servers: a swap file and Emacs |
| `templates/cloud-init.yaml.j2` | the cloud-config that a rebuild installs |
| `tasks/check_server.yml` | the checks both playbooks run first: the server with your IPv4 exists in this Hetzner project and has the name you wrote |
| `rebuild.yml` | rebuilds one server from the cloud-config (asks you to type its name) |
| `site.yml` | the firewall, a reboot if updates need one, the checks, then the roles |
| `roles/<role>/` | one folder per role ("The roles" below) |
| `requirements.yml` | the Ansible collection this needs |

## Once: the control machine

Ansible doesn't run on Windows: use a Linux machine (or WSL) with Python 3.11 or newer.

```bash
pipx install --include-deps ansible
pipx inject ansible requests python-dateutil   # what hetzner.hcloud needs on this machine
ansible-galaxy collection install -r requirements.yml
```

- **The key `~/.ssh/id_ed25519_servers` must exist on this machine.** Ansible logs in with it, and its `.pub` goes into the
  cloud-config.
- **Other devices' keys** (to log in from your PC too): copy their `.pub` files to this machine and add the paths under
  `admin_ssh_pub_key_files` in `group_vars/all.yml`. Never paste a key line into this repo: with a public key and the user name, anyone
  can test which servers accept that key. Keys are set by a rebuild, so add them before one.
- **In each new shell, the Hetzner API token** (Console → your project → Security → API tokens, Read & Write):

  ```bash
  read -rs HCLOUD_TOKEN && export HCLOUD_TOKEN    # paste it: not shown, not saved in the history
  ```

  A token reaches only its own project, so keep your servers in one project (Console → the server → Transfer to Project).

## Once: your inventory

```bash
cp inventory.example.yml inventory.yml
```

For each server, set a short handle (you type it after `--limit`), its **IPv4** and its **name in the Hetzner Console**. List the
development servers under `toolbox` too. Before anything runs, both playbooks ask the Hetzner API for the server with that IPv4 and
stop unless it has that name, so a typo in either one can't reach another server.

**Protect the servers you never want wiped:** in the Console, the server → Protection → delete and rebuild protection (Hetzner keeps
the two together). Then no tool, this one included, can rebuild or delete that server until you turn the protection off.

## A new server

Until `create.yml` comes, create the server in the Hetzner Console: Ubuntu 26.04 (`server_image` in `group_vars/all.yml`), your
servers key, the same project. Then add it to `inventory.yml` and follow "A rebuild" below: the rebuild installs the cloud-config.

## A rebuild

Run everything from this folder, so Ansible picks up `ansible.cfg` and, through it, your `inventory.yml`. The examples use the handle
`dev`.

1. **Before it, check:**
   - the server is in `inventory.yml`, with its current IPv4 and its console name;
   - `HCLOUD_TOKEN` belongs to the server's project;
   - the server's rebuild protection is off (Console → the server → Protection);
   - anything you want from its disk is saved.
2. **Check the files** (changes nothing):

   ```bash
   ansible-playbook rebuild.yml site.yml --syntax-check
   ```
3. **Rebuild.** This WIPES the server's disk. It asks you to type the server's console name:

   ```bash
   ansible-playbook rebuild.yml --limit dev
   ```
4. **See what `site.yml` would change** (changes nothing):

   ```bash
   ansible-playbook site.yml --limit dev --check --diff
   ```
5. **Apply it:**

   ```bash
   ansible-playbook site.yml --limit dev
   ```
6. **Run step 5 again: expect `changed=0`.** Anything else means a task isn't safe to re-run.
7. **Log in and look:** `ssh -o IdentitiesOnly=yes -i ~/.ssh/id_ed25519_servers arthur@<its IPv4>`. The login banner shows the server's
   console name.

To shorten logging in, add an entry to `~/.ssh/config` on your machine (not in this repo):

```
Host dev
    HostName <its IPv4>
    User arthur
    IdentityFile ~/.ssh/id_ed25519_servers
    IdentitiesOnly yes
```

## Adding a tool, one role at a time

A new role runs on its own first. After that, it's part of every full run (step 5 above).

1. **Check the files:** `ansible-playbook rebuild.yml site.yml --syntax-check`
2. **See what it would change:** `ansible-playbook site.yml --limit dev --tags <role> --check --diff`
3. **Apply it:** `ansible-playbook site.yml --limit dev --tags <role>`
4. **Run step 3 again: expect `changed=0`.**

`--tags <role>` still runs the server checks and the waits for SSH and cloud-init (those tasks are tagged `always`). It skips the
firewall, the reboot and the base-system checks, so trying a role several times doesn't count towards fail2ban's limit (see below).
After a rebuild, run the whole `site.yml` first.

### The roles

| Role (its tag) | Runs on | What it sets up |
|---|---|---|
| `base` | every server | htop, tmux, unzip; the login banner (`/etc/update-motd.d/99-figlet`): figlet with the server's console name, then `motd_greeting` (`group_vars/all.yml`) as a plain line. On `toolbox` servers also `base_extra_packages`: Emacs (`emacs-nox`) |

## Sharing a run's output

Keep each output with `2>&1 | tee <name>.log` (git ignores `*.log`). Normal output shows no addresses, but `-v` or an error message
may. Before sharing a log, mask them:

```bash
sed -E 's/([0-9]{1,3}\.){3}[0-9]{1,3}/<IP>/g' <name>.log
```

Never share the token.

## If something fails

- **"No server in this Hetzner project has …" or "The server with … is named …":** your `inventory.yml` doesn't match the Console.
  Check the address and the name, and that `HCLOUD_TOKEN` belongs to the server's project.
- **`skipping: no hosts matched`:** `inventory.yml` is missing, or the handle after `--limit` isn't in it.
- **`cloud-init` problems:** on the server, `/var/log/cloud-init-output.log` has every command's output.
- **`become` fails on Ubuntu 26.04:** its default `sudo` is `sudo-rs`. Our user has password-less sudo, which works with a current
  Ansible. If it still fails, add `-e ansible_become_exe=sudo.ws` to use the classic sudo.
- **SSH says "REMOTE HOST IDENTIFICATION HAS CHANGED":** expected once after a rebuild. `rebuild.yml` removes the old key, but if you
  connected another way, run `ssh-keygen -R <its IPv4>`.
- **SSH suddenly times out:** fail2ban may have banned your address after 5 failed logins in 10 minutes. `site.yml`'s root-login check
  counts as one per run. Wait 10 minutes (the default ban time), or connect from another address. The user has no password, so the
  Hetzner web console can't log in; the rescue system is the last resort.
