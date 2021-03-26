## Free the underlying digest context on OpenSSL 0.9.0

The code under OpenSSL 0.9.0 was using EVP_MD_CTX_cleanup, which doesn't free the underlying context. This means that the memory allocated with EVP_MD_CTX_create would never be freed, leading to a potential memory leak. This is now fixed by using the appropriate function, EVP_MD_CTX_destroy.

## Forward prepare for coming breaking FFI change in ponyc

Added FFI declarations to all FFI calls in the library. The change has no impact on end users, but will future proof against a coming breaking change in FFI in the ponyc compiler. Users of this version of the library won't be impacted by the coming change.

