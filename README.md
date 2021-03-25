# crypto

Library of common cryptographic algorithms and functions for Pony. Requires LibreSSL or OpenSSL. See installation for more details.

## Status

Production ready.

## Installation

* Install [corral](https://github.com/ponylang/corral)
* `corral add github.com/ponylang/crypto.git --version 1.1.1`
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

## Examples

### Producing a hash from a single fixed-length byte array

```pony
// SHA256
let sha256hash: Array[U8] val = SHA256("Hello World")
env.out.print("SHA256: " + ToHexString(sha256hash))

// MD5
let md5hash: Array[U8] val = MD5("Hello World")
env.out.print("MD5: " + ToHexString(md5hash))

// SHA1
let sha1hash: Array[U8] val = SHA1("Hello World")
env.out.print("SHA1: " + ToHexString(sha1hash))
```

### Producing a hash from chunks of input

```pony
let sha256digest: Digest = Digest.sha256()
try
  sha256digest.append("Hello ")?
  sha256digest.append("World")?
  let hash: Array[U8] val = sha256digest.final()
  env.out.print("SHA256: " + ToHexString(hash))
else
  env.out.print("Error computing hash")
end
```

Example can be found within the [examples](./examples) folder in this repository

## API Documentation

[https://ponylang.github.io/crypto/](https://ponylang.github.io/crypto/)
