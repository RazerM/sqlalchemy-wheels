# sqlalchemy-wheels

This repository is used to build wheels for Windows, Linux ([manylinux1][]), and macOS.

[manylinux1]: https://www.python.org/dev/peps/pep-0513/

# Setup
For PyPI uploads to work, set `PYPI_USERNAME` and `PYPI_PASSWORD` in `.travis.yml` and `appveyor.yml`.

Instructions:
- [Travis](https://docs.travis-ci.com/user/encryption-keys/#Usage)
- [AppVeyor](https://www.appveyor.com/docs/build-configuration/#secure-variables)

# Trigger a build

## Manually
1. Typically, edit both `appveyor.yml` and `.travis.yml`:
   1. Set `BUILD_COMMIT` to a commit, tag, or branch. This would typically be a release tag.
   2. Set `UPLOAD_TO_PYPI` to `true` or `false`.
2. Push the changes: `git commit -m "Build x.y.z" && git push`

## Script
`pushbuild.sh` does the following:
- Sets `UPLOAD_TO_PYPI` to `true` unless `-u` is passed.
- Sets `BUILD_COMMIT` to the first positional argument.
- Commits and pushes the changes.
- Resets `UPLOAD_TO_PYPI` to `false` and commits the change.

### Example
```bash
# Build 1.1.4 and upload to PyPI
./pushbuild.sh -u rel_1_1_4
# Build 1.0.0 but don't upload
./pushbuild.sh rel_1_0_0
```
