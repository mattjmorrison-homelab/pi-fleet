#!/usr/bin/env bats

setup() {
  export FLEET_YAML="$BATS_TEST_DIRNAME/../../fleet.yaml"
  export GITHUB_OUTPUT="$BATS_TEST_TMPDIR/github_output"
  : > "$GITHUB_OUTPUT"
  SCRIPT="$BATS_TEST_DIRNAME/../resolve-target.sh"
}

@test "resolves ssh-host and ssh-user for a known pi" {
  export NAME="pi1"
  run bash "$SCRIPT"
  [ "$status" -eq 0 ]
  grep -qF "ssh-host=pi1.local" "$GITHUB_OUTPUT"
  grep -qF "ssh-user=pi" "$GITHUB_OUTPUT"
}

@test "fails loudly and leaves GITHUB_OUTPUT untouched for an unknown pi" {
  export NAME="nonexistent"
  run bash "$SCRIPT"
  [ "$status" -ne 0 ]
  [[ "$output" == *"nonexistent"* ]]
  [[ "$output" == *"fleet.yaml"* ]]
  [ ! -s "$GITHUB_OUTPUT" ]
}

@test "fails loudly when NAME is unset" {
  unset NAME
  run bash "$SCRIPT"
  [ "$status" -ne 0 ]
  [[ "$output" == *"NAME"* ]]
}

@test "fails loudly when FLEET_YAML is unset" {
  export NAME="pi1"
  unset FLEET_YAML
  run bash "$SCRIPT"
  [ "$status" -ne 0 ]
  [[ "$output" == *"FLEET_YAML"* ]]
}
