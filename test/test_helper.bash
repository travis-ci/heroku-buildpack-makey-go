setup() {
  export TOP="$(cd $BATS_TEST_DIRNAME/.. && pwd)"
  export PATH=$TOP/bin:$PATH
  export TMP=$TOP/test/.tmp
  mkdir -p $TMP
  export TEST_HTTP_SERVER="$(start_test_http_server $TMP)"
}

teardown() {
  if [[ -f $TMP/test_http_server.pid ]] ; then
    local test_http_server_pid=$(cat $TMP/test_http_server.pid)
  fi
  if [[ -n "$test_http_server_pid" ]] ; then
    kill "$test_http_server_pid" || echo "Suppressing exit $?"
  fi
  rm -rf $TMP
}

start_test_http_server() {
  pushd $1 &>/dev/null
  python -m SimpleHTTPServer 19494 &>$1/server.log &
  echo $! > $1/test_http_server.pid
  popd &>/dev/null
  echo 'localhost:19494'
}
