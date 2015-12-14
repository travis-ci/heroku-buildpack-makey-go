#!/usr/bin/env bats

load test_helper

setup_download() {
  export S3_HOST="http://$TEST_HTTP_SERVER"
  export SOURCE_VERSION='fafafaf'

  mkdir -p $1/replace-me-example-artifacts/replace-me/example/$SOURCE_VERSION/
  mkdir -p $1/dl/build/linux/amd64

  echo '#!/usr/bin/env bash' > $1/dl/build/linux/amd64/number
  echo "echo $2" >> $1/dl/build/linux/amd64/number

  chmod +x $1/dl/build/linux/amd64/number

  pushd $1/dl &>/dev/null
  tar -czf \
    $1/replace-me-example-artifacts/replace-me/example/$SOURCE_VERSION/build.tar.gz \
    build
  popd &>/dev/null
}

@test "compiling with binary download" {
  mkdir -p $TMP/build $TMP/cache $TMP/env
  NUMBER="$RANDOM"
  setup_download $TMP $NUMBER

  DEBUG=1 run compile $TMP/build $TMP/cache $TMP/env

  echo "$output" | tee $TMP/output

  [ $status -eq 0 ]

  grep -q '^-----> Downloading ' $TMP/output
  grep -q '^-----> Expanding build.tar.gz' $TMP/output

  [ ! -f $TMP/cache/.gimme.tar.bz2 ]
  [ ! -f $TMP/build/.gimme.tar.bz2 ]
  [ ! -d $TMP/build/.gimme/versions ]
  [ -f $TMP/build/build/linux/amd64/number ]
  [ `$TMP/build/build/linux/amd64/number` = $NUMBER ]
}
