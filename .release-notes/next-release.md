## Free the underlying digest context on OpenSSL 0.9.0

The code under OpenSSL 0.9.0 was using EVP_MD_CTX_cleanup, which doesn't free the underlying context. This means that the memory allocated with EVP_MD_CTX_create would never be freed, leading to a potential memory leak. This is now fixed by using the appropriate function, EVP_MD_CTX_destroy.

