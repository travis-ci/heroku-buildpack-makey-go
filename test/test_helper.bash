setup() {
  export TOP="$(cd $BATS_TEST_DIRNAME/.. && pwd)"
  export PATH=$TOP/bin:$PATH
  export TMP=$TOP/test/.tmp
  mkdir -p $TMP
}

teardown() {
  rm -rf $TMP
}
