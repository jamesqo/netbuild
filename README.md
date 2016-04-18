# netbuild

Script templates for building .NET Core projects

## Usage

```bash
cd myrepo

# Build scripts
curl -sSLo build.sh https://github.com/jamesqo/netbuild/raw/master/build.sh && chmod a+rx build.sh
curl -sSLo build.cmd https://github.com/jamesqo/netbuild/raw/master/build.cmd

# Publish scripts
curl -sSLo publish.cmd https://github.com/jamesqo/netbuild/raw/master/publish.cmd

# CI templates
curl -sSLo .travis.yml https://github.com/jamesqo/netbuild/raw/master/ci/.travis.yml
curl -sSLo appveyor.yml https://github.com/jamesqo/netbuild/raw/master/ci/appveyor.yml
```

## License

[MIT](LICENSE)
