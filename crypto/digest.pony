use "path:/usr/local/opt/libressl/lib" if osx and x86
use "path:/opt/homebrew/opt/libressl/lib" if osx and arm
use "lib:crypto"
use "lib:bcrypt" if windows

use @EVP_MD_CTX_new[Pointer[_EVPCTX]]() if "openssl_1.1.x" or "openssl_3.0.x"
use @EVP_MD_CTX_create[Pointer[_EVPCTX]]() if not "openssl_1.1.x" or "openssl_3.0.x"
use @EVP_DigestInit_ex[I32](ctx: Pointer[_EVPCTX] tag, t: Pointer[_EVPMD], impl: USize)
use @EVP_DigestUpdate[I32](ctx: Pointer[_EVPCTX] tag, d: Pointer[U8] tag, cnt: USize)
use @EVP_DigestFinal_ex[I32](ctx: Pointer[_EVPCTX] tag, md: Pointer[U8] tag, s: Pointer[USize])
use @EVP_MD_CTX_free[None](ctx: Pointer[_EVPCTX]) if "openssl_1.1.x" or "openssl_3.0.x"
use @EVP_MD_CTX_destroy[None](ctx: Pointer[_EVPCTX]) if not "openssl_1.1.x" or "openssl_3.0.x"

use @EVP_md5[Pointer[_EVPMD]]()
use @EVP_ripemd160[Pointer[_EVPMD]]()
use @EVP_sha1[Pointer[_EVPMD]]()
use @EVP_sha224[Pointer[_EVPMD]]()
use @EVP_sha256[Pointer[_EVPMD]]()
use @EVP_sha384[Pointer[_EVPMD]]()
use @EVP_sha512[Pointer[_EVPMD]]()
use @EVP_shake128[Pointer[_EVPMD]]()
use @EVP_shake256[Pointer[_EVPMD]]()

primitive _EVPMD
primitive _EVPCTX

class Digest
  """
  Produces a hash from the chunks of input. Feed the input with append() and
  produce a final hash from the concatenation of the input with final().
  """
  let _digest_size: USize
  let _ctx: Pointer[_EVPCTX]
  var _hash: (Array[U8] val | None) = None

  new md5() =>
    """
    Use the MD5 algorithm to calculate the hash.
    """
    _digest_size = 16
    ifdef "openssl_1.1.x" or "openssl_3.0.x" then
      _ctx = @EVP_MD_CTX_new()
    else
      _ctx = @EVP_MD_CTX_create()
    end
    @EVP_DigestInit_ex(_ctx, @EVP_md5(), USize(0))

  new ripemd160() =>
    """
    Use the RIPEMD160 algorithm to calculate the hash.
    """
    _digest_size = 20
    ifdef "openssl_1.1.x" or "openssl_3.0.x" then
      _ctx = @EVP_MD_CTX_new()
    else
      _ctx = @EVP_MD_CTX_create()
    end
    @EVP_DigestInit_ex(_ctx, @EVP_ripemd160(), USize(0))

  new sha1() =>
    """
    Use the SHA1 algorithm to calculate the hash.
    """
    _digest_size = 20
    ifdef "openssl_1.1.x" or "openssl_3.0.x" then
      _ctx = @EVP_MD_CTX_new()
    else
      _ctx = @EVP_MD_CTX_create()
    end
    @EVP_DigestInit_ex(_ctx, @EVP_sha1(), USize(0))

  new sha224() =>
    """
    Use the SHA256 algorithm to calculate the hash.
    """
    _digest_size = 28
    ifdef "openssl_1.1.x" or "openssl_3.0.x" then
      _ctx = @EVP_MD_CTX_new()
    else
      _ctx = @EVP_MD_CTX_create()
    end
    @EVP_DigestInit_ex(_ctx, @EVP_sha224(), USize(0))

  new sha256() =>
    """
    Use the SHA256 algorithm to calculate the hash.
    """
    _digest_size = 32
    ifdef "openssl_1.1.x" or "openssl_3.0.x" then
      _ctx = @EVP_MD_CTX_new()
    else
      _ctx = @EVP_MD_CTX_create()
    end
    @EVP_DigestInit_ex(_ctx, @EVP_sha256(), USize(0))

  new sha384() =>
    """
    Use the SHA384 algorithm to calculate the hash.
    """
    _digest_size = 48
    ifdef "openssl_1.1.x" or "openssl_3.0.x" then
      _ctx = @EVP_MD_CTX_new()
    else
      _ctx = @EVP_MD_CTX_create()
    end
    @EVP_DigestInit_ex(_ctx, @EVP_sha384(), USize(0))

  new sha512() =>
    """
    Use the SHA512 algorithm to calculate the hash.
    """
    _digest_size = 64
    ifdef "openssl_1.1.x" or "openssl_3.0.x" then
      _ctx = @EVP_MD_CTX_new()
    else
      _ctx = @EVP_MD_CTX_create()
    end
    @EVP_DigestInit_ex(_ctx, @EVP_sha512(), USize(0))

  new shake128() =>
    """
    Use the Shake128 algorithm to calculate the hash.
    """
    _digest_size = 16
    ifdef "openssl_1.1.x" or "openssl_3.0.x" then
      _ctx = @EVP_MD_CTX_new()
      @EVP_DigestInit_ex(_ctx, @EVP_shake128(), USize(0))
    else
      compile_error "openssl_0.9.x dose not support shake128"
    end

  new shake256() =>
    """
    Use the Shake256 algorithm to calculate the hash.
    """
    _digest_size = 32
    ifdef "openssl_1.1.x" or "openssl_3.0.x" then
      _ctx = @EVP_MD_CTX_new()
      @EVP_DigestInit_ex(_ctx, @EVP_shake256(), USize(0))
    else
      compile_error "openssl_0.9.x dose not support shake256"
    end

  fun ref append(input: ByteSeq) ? =>
    """
    Update the Digest object with input. Throw an error if final() has been
    called.
    """
    if _hash isnt None then error end
    @EVP_DigestUpdate(_ctx, input.cpointer(), input.size())

  fun ref final(): Array[U8] val =>
    """
    Return the digest of the strings passed to the append() method.
    """
    match _hash
    | let h: Array[U8] val => h
    else
      let size = _digest_size
      let digest =
        recover String.from_cpointer(
          @pony_alloc(@pony_ctx(), size), size)
        end
      @EVP_DigestFinal_ex(_ctx, digest.cpointer(), Pointer[USize])
      ifdef "openssl_1.1.x" or "openssl_3.0.x" then
        @EVP_MD_CTX_free(_ctx)
      else
        @EVP_MD_CTX_destroy(_ctx)
      end
      let h = (consume digest).array()
      _hash = h
      h
    end

  fun digest_size(): USize =>
    """
    Return the size of the message digest in bytes.
    """
    _digest_size
