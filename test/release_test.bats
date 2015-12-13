#!/usr/bin/env bats

load test_helper

@test "releasing" {
  mkdir -p $TMP/build
  run release $TMP/build
  [ $status -eq 0 ]
  [ "$output" = "--- {}" ]
}
