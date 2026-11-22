#!/usr/bin/env bash
set -euo pipefail

NAME="${NAME:?NAME is required}"
FLEET_YAML="${FLEET_YAML:?FLEET_YAML is required}"

HOST="$(yq -r ".pis.\"${NAME}\".ssh_host // \"\"" "$FLEET_YAML")"
USER="$(yq -r ".pis.\"${NAME}\".ssh_user // \"\"" "$FLEET_YAML")"
if [[ -z "$HOST" || -z "$USER" ]]; then
  echo "'$NAME' isn't a known pi in $FLEET_YAML -- add it there first." >&2
  exit 1
fi

echo "ssh-host=$HOST" >> "$GITHUB_OUTPUT"
echo "ssh-user=$USER" >> "$GITHUB_OUTPUT"
