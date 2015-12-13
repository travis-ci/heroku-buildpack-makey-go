# `heroku-buildpack-makey-go`

Heroku buildpack for (some) Go projects (maybe).

## how?

If a `heroku` target is detected, run `make heroku`.

Otherwise, attempt to download and expand a bzipped tarball, the URL
for which may either be explicitly given as `GO_BINARY_URL` or will
be convention-style constructed from the `GO_IMPORT_PATH` value, e.g.:

```
heroku config:set GO_IMPORT_PATH=github.com/serious-company/whizbang
```

becomes:

```
GO_BINARY_URL="https://s3.amazonaws.com/serious-company-whizbang-artifacts/serious-company/whizbang/$SOURCE_VERSION/build.tar.bz2"
```

**NOTE**: The [`$SOURCE_VERSION`
variable](https://devcenter.heroku.com/articles/buildpack-api#bin-compile-summary)
is present in the heroku env at slug compile time.
