# sshd Feature

Installs and hardens an OpenSSH server so the dev container can be reached over SSH — by
VS Code Remote-SSH, by an editor running on the host, or by a plain `ssh` session.

## OS Support

Red Hat UBI9/UBI10 and Fedora 43. `bash` is required to execute `install.sh`. Installation is
orchestrated by `/opt/bootstrap/run-feature.sh`, provided by the `bootstrap` feature.

This feature runs in the **privileged lane**: it installs the `openssh-server` RPM and writes to
`/etc/ssh`. Only `git`, `git-lfs` and this feature do that.

## Configuration

Settings are written to `/etc/ssh/sshd_config.d/10-trusted-devcontainer.conf` rather than by
replacing `sshd_config`. Fedora's stock configuration carries `Include /etc/ssh/sshd_config.d/*.conf`
near the top, and sshd keeps the **first** value it obtains for a keyword — so the `10-` prefix wins
over the distribution's own `40-` and `50-` drop-ins without either being edited.

The policy is public-key only: `AuthenticationMethods publickey`, no passwords, no
keyboard-interactive, no root login, `AllowUsers` limited to the container user, no X11 forwarding.
Agent forwarding is left enabled, as it is on the other developer workspaces in this organization —
it is how a forwarded key reaches `git push` from inside the container.

## Two lanes, because the container user decides what sshd can do

These templates set `containerUser: dev`, so the entrypoint runs **unprivileged**. That matters: an
unprivileged sshd cannot read `/etc/ssh`'s root-owned host keys and cannot use PAM.

The entrypoint therefore picks a lane at runtime:

| Running as | Host key | Config | Who can log in |
| --- | --- | --- | --- |
| root | `/etc/ssh/ssh_host_*` | the `10-` drop-in | the container user, per `AllowUsers` |
| non-root | `~/.ssh/sshd/ssh_host_ed25519_key` | `~/.ssh/sshd/sshd_config` | only the user running sshd |

Both configurations render from **one template**, so the hardening cannot drift between them. Both
are validated with `sshd -t` at install time, and again before start. The rootless lane's restriction
— it can only ever admit the user running it — is precisely the `AllowUsers` policy the config
already states, so nothing is lost by it.

## Two things that will silently break SSH if you change them

**The locked account.** The base image creates its user with `useradd` and no password, leaving `!`
in `/etc/shadow`. OpenSSH treats that as a *locked account* and refuses public-key authentication
before it ever opens `authorized_keys`. The failure looks like a rejected key and nothing in the logs
says "locked". The role sets the password field to `*`, which means "no password login" without
meaning "locked".

**Host key rotation.** Host keys are generated at install time and baked into the image, so they
change on every rebuild. That is the existing convention here, and it is why the matching SSH client
config for these workspaces sets `StrictHostKeyChecking no` and `UserKnownHostsFile /dev/null` — with
checking on, a rebuild greets every developer with `REMOTE HOST IDENTIFICATION HAS CHANGED`. If you
need a stable host identity, mount the host keys in and let the entrypoint use them instead.

## Authorized keys

**No key material is ever baked into the image or written into `devcontainer.json`.** At container
start the entrypoint reads public keys from `authorized_keys_path` (default
`/run/secrets/authorized_keys`) and installs them to the user's `~/.ssh/authorized_keys` with mode
`0600`.

If nothing is mounted there, the container still starts — sshd runs, logs a warning, and admits
no one. A missing key file is a configuration gap, not a reason to fail a developer's container.

## Starting

This is the only feature in the collection that declares an `entrypoint`. Every other feature
finishes its work at install time; sshd has to be started again on each container start, which is
what the entrypoint chain is for. `/usr/local/share/ssh-init.sh` starts sshd in the background and
then `exec`s the command it was handed, so the container's real command still runs.

A failure to start sshd is logged loudly but is never fatal — losing remote access is a better
outcome than bricking the whole container over its SSH daemon.

## Example Usage

```json
// devcontainer.json
"features": {
    "ghcr.io/infrashift/trusted-devcontainer-features/sshd": {}
},
"mounts": [
    "source=${localEnv:HOME}/.ssh/id_ed25519.pub,target=/run/secrets/authorized_keys,type=bind,readonly"
],
"appPort": ["2222:2222"]
```

Then:

```bash
ssh -p 2222 -i ~/.ssh/id_ed25519 dev@localhost
```

*Choose a different port and key location:*

```json
// devcontainer.json
"features": {
    "ghcr.io/infrashift/trusted-devcontainer-features/sshd": {
        "sshd_port": "2200",
        "authorized_keys_path": "/run/secrets/ssh/authorized_keys"
    }
}
```
