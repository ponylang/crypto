# crypto

Library of common cryptographic algorithms and functions for Pony. Requires LibreSSL or OpenSSL. See installation for more details.

## Status

Deprecated. Use [ponylang/ssl](https://github.com/ponylang/ssl) instead.

To update from `crypto` to `ssl`, should update your dependency in corral.json to the most recent ponylang/ssl version. As of version 1.0.0, the API is compatible with `crypto` but there is a small breaking change. Where you previously had `use "crypto"` you will now need to do `use "ssl/crypto"`.
