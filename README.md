# pi-fleet

The Pi fleet's node inventory: name, SSH host, and SSH user for each Pi.
Nothing else — no provisioning logic, no scripts, no CI that connects to
a Pi.

## `fleet.yaml`

One entry per Pi under `pis:`, each with `ssh_host` and `ssh_user`.
`ssh_user` is `pi` for every node today, matching `admin-openbao`'s
`pi-fleet` SSH role (`allowed_users = "pi"`).

## Relationship to other repos

- `pi-provision` owns the actual provisioning scripts and target
  resolution (`resolve-adhoc-target.sh`, `pi-ssh-host.sh`) and its own
  copy of the fleet list for that purpose. This repo's `fleet.yaml`
  captures the same underlying facts in a minimal, dependency-free form
  for consumers that only need to know how to reach each Pi.
- `admin-openbao` owns the SSH certificate authority that will sign
  short-lived (~5 min TTL) SSH certs for connecting to these Pis,
  replacing static long-lived keys. This repo does not yet use that CA —
  it's metadata only until the CA is set up on the Pis themselves.
