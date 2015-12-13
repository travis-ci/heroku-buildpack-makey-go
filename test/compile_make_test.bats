#!/usr/bin/env bats

load test_helper

setup_make_heroku() {
  pushd $1 &>/dev/null
  cat > Makefile <<EOF
heroku:
	@env | sort > compile.env
EOF
  popd &>/dev/null
}

@test "compiling with make heroku target" {
  mkdir -p $TMP/build $TMP/cache $TMP/env
  setup_make_heroku $TMP/build
  DEBUG=1 run compile $TMP/build $TMP/cache $TMP/env

  echo "$output" | tee $TMP/output

  [ $status -eq 0 ]

  grep -q '^-----> Downloading gimme' $TMP/output
  grep -q '^-----> Installing go 1.5.1' $TMP/output
  grep -q "^-----> Copying $TMP/build to" $TMP/output
  grep -q '^-----> Setting up GOROOT, GOPATH, and PATH' $TMP/output
  grep -q '^-----> Running make heroku' $TMP/output
  grep -q "^-----> Compressing $TMP/cache/.gimme" $TMP/output
  grep -q "^-----> Syncing cache dir to build dir..." $TMP/output

  [ -f $TMP/build/compile.env ]
  grep -q '^GO15VENDOREXPERIMENT=' $TMP/build/compile.env
  grep -q '^GO_BINARY_PATH_DIR=' $TMP/build/compile.env
  grep -q '^GO_BINARY_URL=' $TMP/build/compile.env
  grep -q '^GO_IMPORT_PATH=github.com/replace-me/example' $TMP/build/compile.env
  grep -q '^GO_VERSION=1.5.1' $TMP/build/compile.env

  [ -f $TMP/cache/.gimme.tar.bz2 ]
  [ ! -f $TMP/build/.gimme.tar.bz2 ]
  [ ! -d $TMP/build/.gimme/versions ]
}
