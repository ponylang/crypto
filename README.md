# crypto

Library of common cryptographic algorithms and functions for Pony. Requires LibreSSL or OpenSSL. See installation for more details.

## Status

[![Actions Status](https://github.com/ponylang/crypto/workflows/vs-ponyc-latest/badge.svg)](https://github.com/ponylang/crypto/actions)

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

```
sudo apt-get install -y libssl-dev
```

### Installing on Alpine Linux

```
apk add --update libressl-dev
```

### Installing on Arch Linux

```
pacman -S openssl

```

### Installing on macOS with Homebrew

```
brew update
brew install libressl
```

#### Installing on macOS with MacPorts

```
sudo port install libressl
```

### Installing on RPM based Linux distributions with dnf

```
sudo dnf install openssl-devel
```

### Installing on RPM based Linux distributions with yum

```
sudo yum install openssl-devel
```

### Installing on RPM based Linux distributions with zypper

```
sudo zypper install libopenssl-devel
```
### Installing on Windows

Before using this package, you must run `.\make.ps1 libs` in its base directory to download and build LibreSSL for Windows. You will need CMake and7Zip (`7z.exe`) in your PATH; and Visual Studio 2019 (or the Visual C++ Build Tools 2019).
