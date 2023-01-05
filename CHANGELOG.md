# Change Log

All notable changes to this library will be documented in this file. This project adheres to [Semantic Versioning](http://semver.org/) and [Keep a CHANGELOG](http://keepachangelog.com/).

## [1.2.1] - 2023-01-05

### Changed

- Update to LibreSSL 3.6.1 on Windows ([PR #81](https://github.com/ponylang/crypto/pull/81))

## [1.2.0] - 2023-01-03

### Added

- Add OpenSSL 3 support ([PR #80](https://github.com/ponylang/crypto/pull/80))

### Changed

- Remove `md4` constructor from `Digest` ([PR #78](https://github.com/ponylang/crypto/pull/78))

## [1.1.6] - 2022-05-27

### Added

- Add path to Homebrew's LibreSSL on ARM macOS ([PR #73](https://github.com/ponylang/crypto/pull/73))

## [1.1.5] - 2022-02-26

### Fixed

- Update to address PonyTest package being renamed ([PR #67](https://github.com/ponylang/crypto/pull/67))
- Updates for libs build on Windows ([PR #68](https://github.com/ponylang/crypto/pull/68))

## [1.1.4] - 2022-02-10

### Added

- Support for using ponyup on Windows ([PR #66](https://github.com/ponylang/crypto/pull/66))

## [1.1.3] - 2021-04-10

### Changed

- Remove explicit return type from FFI calls ([PR #57](https://github.com/ponylang/crypto/pull/57))

## [1.1.2] - 2021-03-26

### Fixed

- Free the underlying digest context on OpenSSL 0.9.0 ([PR #55](https://github.com/ponylang/crypto/pull/55))

### Changed

- Declare all FFI functions ([PR #56](https://github.com/ponylang/crypto/pull/56))

## [1.1.1] - 2021-02-08

## [1.1.0] - 2020-08-22

### Added

- Build Windows libs upon fetch or update ([PR #45](https://github.com/ponylang/crypto/pull/45))

## [1.0.2] - 2020-08-13

### Added

- Added Shake128/256 Digest support ([PR #28](https://github.com/ponylang/crypto/pull/28))
- Added MD4 digest ([PR #27](https://github.com/ponylang/crypto/pull/27))
- Made Windows installation easier (https://github.com/ponylang/crypto/commit/bed88fa975ec23153e926551c020c2241763f114)

## [1.0.1] - 2020-05-17

### Fixed

- Improve performance of constant time comparison ([PR #24](https://github.com/ponylang/crypto/pull/24))

## [1.0.0] - 2019-09-02

### Added

- Initial version

