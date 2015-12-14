#!/usr/bin/env bats

load test_helper

setup_make_heroku_bin() {
  pushd $1 &>/dev/null
  cat > Makefile <<EOF
heroku:
	@env | sort > compile.env

heroku-bin:
	@env | sort > compile.env
	@echo HEROKU BIN > bin.txt
EOF
  popd &>/dev/null
}

@test "compiling with make heroku-bin target" {
  mkdir -p $TMP/build $TMP/cache $TMP/env
  setup_make_heroku_bin $TMP/build
  DEBUG=1 run compile $TMP/build $TMP/cache $TMP/env

  echo "$output" | tee $TMP/output

  [ $status -eq 0 ]

  grep -q '^-----> Running make heroku-bin' $TMP/output
  grep -q "^-----> Syncing cache dir to build dir..." $TMP/output

  [ -f $TMP/build/compile.env ]
  grep -q '^GO15VENDOREXPERIMENT=' $TMP/build/compile.env
  grep -q '^GO_BINARY_PATH_DIR=' $TMP/build/compile.env
  grep -q '^GO_BINARY_URL=' $TMP/build/compile.env
  grep -q '^GO_IMPORT_PATH=github.com/replace-me/example' $TMP/build/compile.env
  grep -q '^GO_VERSION=1.5.1' $TMP/build/compile.env

  [ -f $TMP/build/bin.txt ]
  grep -q 'HEROKU BIN' $TMP/build/bin.txt

  [ ! -f $TMP/cache/.gimme.tar.bz2 ]
  [ ! -f $TMP/build/.gimme.tar.bz2 ]
  [ ! -d $TMP/build/.gimme/versions ]
}
