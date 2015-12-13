#!/usr/bin/env bats

load test_helper

@test "detecting a valid makey-go project" {
  mkdir -p $TMP/build
  touch $TMP/build/Makefile
  run detect $TMP/build
  [ $status -eq 0 ]
  [ "$output" = "makey-go" ]
}

@test "rejecting an invalid makey-go project" {
  mkdir -p $TMP/build
  rm -f $TMP/build/Makefile
  run detect $TMP/build
  [ $status -eq 1 ]
  [ "$output" = "no" ]
}
