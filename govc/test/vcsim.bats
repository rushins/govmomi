#!/usr/bin/env bats

load test_helper

@test "vcsim rbvmomi" {
  if ! ruby -e "require 'rbvmomi'" ; then
    skip "requires rbvmomi"
  fi

  vcsim_env

  ruby ./vcsim_test.rb "$(govc env -x GOVC_URL_PORT)"
}

@test "vcsim examples" {
  vcsim_env

  # compile + run examples against vcsim
  for main in ../../examples/*/main.go ; do
    run go run "$main" -insecure -url "$GOVC_URL"
    assert_success
  done
}

@test "vcsim about" {
  vcsim_env

  run curl -sk https://"$(govc env GOVC_URL)"/about
  assert_matches "CurrentTime" # 1 param (without Context)
  assert_matches "TerminateSession" # 2 params (with Context)
}
