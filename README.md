# crypto

Library of common cryptographic algorithms and functions for Pony. Requires LibreSSL or OpenSSL. See installation for more details.

## Status

Production ready.

## Installation

* Install [corral](https://github.com/ponylang/corral)
* `corral add github.com/ponylang/crypto.git`
* `corral fetch` to fetch your dependencies
* `use "crypto"` to include this package
* `corral run -- ponyc` to compile your application

## Dependencies

`crypto` requires either LibreSSL or OpenSSL in order to operate. You'll might need to install it within your environment of choice.

### Installing on APT based Linux distributions

```bash
sudo apt-get install -y libssl-dev
```

### Installing on Alpine Linux

```bash
apk add --update libressl-dev
```

### Installing on Arch Linux

```bash
pacman -S openssl
```

### Installing on macOS with Homebrew

```bash
brew update
brew install libressl
```

#### Installing on macOS with MacPorts

```bash
sudo port install libressl
```

### Installing on RPM based Linux distributions with dnf

```bash
sudo dnf install openssl-devel
```

### Installing on RPM based Linux distributions with yum

```bash
sudo yum install openssl-devel
```

### Installing on RPM based Linux distributions with zypper

```bash
sudo zypper install libopenssl-devel
```

### Installing on Windows

If you use [Corral](https://github.com/ponylang/corral) to include this package as dependency of a project, Corral will download and build LibreSSL for you the first time you run `corral fetch`.  Otherwise, before using this package, you must run `.\make.ps1 libs` in its base directory to download and build LibreSSL for Windows. In both cases, you will need CMake (3.15 or higher) and 7Zip (`7z.exe`) in your `PATH`; and Visual Studio 2019 (or the Visual C++ Build Tools 2019) installed in your system.

You should pass `--define openssl_0.9.0` to Ponyc when using this package on Windows.
