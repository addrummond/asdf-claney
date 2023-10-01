<div align="center">

# asdf-claney [![Build](https://github.com/addrummond/asdf-claney/actions/workflows/build.yml/badge.svg)](https://github.com/addrummond/asdf-claney/actions/workflows/build.yml) [![Lint](https://github.com/addrummond/asdf-claney/actions/workflows/lint.yml/badge.svg)](https://github.com/addrummond/asdf-claney/actions/workflows/lint.yml)

[claney](https://github.com/addrummond/claney) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`: generic POSIX utilities.
- `SOME_ENV_VAR`: set this environment variable in your shell config to load the correct version of tool x.

# Install

Plugin:

```shell
asdf plugin add claney
# or
asdf plugin add claney https://github.com/addrummond/asdf-claney.git
```

claney:

```shell
# Show all installable versions
asdf list-all claney

# Install specific version
asdf install claney latest

# Set a version globally (on your ~/.tool-versions file)
asdf global claney latest

# Now claney commands are available
claney -version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/addrummond/asdf-claney/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Alex Drummond](https://github.com/addrummond/)
