## Remove `md4` constructor from `Digest`

With the introduction of OpenSSL 3, the OpenSSL developers have moved MD4 to a "legacy provider". What this means is that via the mechanism that the `Digest` class uses, we can no longer cleanly support MD4 without adding bloat that would impact on the usability of the other algorithms supported by `Digest`.

The `md4` constructor has been removed from `Digest`. Note that an alternate method of doing `md4` hashing is still available via the `MD4` primitive.

