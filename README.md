# crypto

Library of common cryptographic algorithms and functions for Pony. Requires LibreSSL or OpenSSL. See installation for more details. 

## Status

[![CircleCI](https://circleci.com/gh/ponylang/crypto.svg?style=svg)](https://circleci.com/gh/ponylang/crypto)

Production ready.

## Installation

* Install [pony-stable](https://github.com/ponylang/pony-stable)
* Update your `bundle.json`

```json
{ 
  "type": "github",
  "repo": "ponylang/crypto",
  "tag": "1.0.0"
}
```

* `stable fetch` to fetch your dependencies
* `use "crypto"` to include this package
* `stable env ponyc` to compile your application

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

Download a prebuilt binary from [https://www.libressl.org/](https://www.libressl.org/).
