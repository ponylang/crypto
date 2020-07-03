use "ponytest"

actor Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestConstantTimeCompare)

    // test hash
    test(_TestHash[MD4]("md4", "test", "db346d691d7acc4dc2625db19f9e3f52"))
    test(_TestHash[MD5]("md5", "test", "098f6bcd4621d373cade4e832627b4f6"))
    test(_TestHash[RIPEMD160]("ripemd160", "test",
      "5e52fee47e6b070565f74372468cdc699de89107"))
    test(_TestHash[SHA1]("sha1", "test",
      "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3"))
    test(_TestHash[SHA224]("sha224", "test",
      "90a3ed9e32b2aaf4c61c410eb925426119e1a9dc53d4286ade99a809"))
    test(_TestHash[SHA256]("sha256", "test",
      "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08"))
    test(_TestHash[SHA384]("sha384", "test",
      "768412320f7b0aa5812fce428dc4706b3cae50e02a64caa16a782249bfe8efc4" +
      "b7ef1ccb126255d196047dfedf17a0a9"))
    test(_TestHash[SHA512]("sha512", "test",
      "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db2" +
      "7ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff"))
    
    // test digest
    test(_TestDigest("md4", ["message1"; "message2"],
      "6f299e11a64b5983b932ae9a682f0379"))
    test(_TestDigest("md5", ["message1"; "message2"],
      "94af09c09bb9bb7b5c94fec6e6121482"))
    test(_TestDigest("ripemd160", ["message1"; "message2"],
      "9813627fca6c51a67ed401cf325c3864cb84ce34"))
    test(_TestDigest("sha1", ["message1"; "message2"],
      "942682e2e49f37b4b224fc1aec1a53a25967e7e0"))
    test(_TestDigest("sha224", ["message1"; "message2"],
      "fbba013f116e8b09b044b2a785ed7fb6a65ce672d724c1fb20500d45"))
    test(_TestDigest("sha256", ["message1"; "message2"],
      "68d9b867db4bde630f3c96270b2320a31a72aafbc39997eb2bc9cf2da21e5213"))
    test(_TestDigest("sha384", ["message1"; "message2"],
      "7736dd67494a7072bf255852bd327406b398cb0b16cb400f"+
      "cd3fcfb6827d74ab9b14673d50515b6273ef15543325f8d3"))
    test(_TestDigest("sha512", ["message1"; "message2"],
      "3511f4825021a90cd55d37db5c3250e6bbcffc9a0d56d88b4e2878ac5b094692"+
      "cd945c6a77006272322f911c9be31fa970043daa4b61cee607566cbfa2c69b09"))
    ifdef "openssl_1.1.x" then
      test(_TestDigest("shake128", ["message1"; "message2"],
        "0d11671f23b6356bdf4ba8dcae37419d"))
      test(_TestDigest("shake256", ["message1"; "message2"],
        "80e2bbb14639e3b1fc1df80b47b67fb518b0ed26a1caddfa10d68f7992c33820"))
    end

class iso _TestConstantTimeCompare is UnitTest
  fun name(): String => "crypto/ConstantTimeCompare"

  fun apply(h: TestHelper) =>
    let s1 = "12345"
    let s2 = "54321"
    let s3 = "123456"
    let s4 = "1234"
    let s5 = recover val [as U8: 0; 0; 0; 0; 0] end
    let s6 = String.from_array([0; 0; 0; 0; 0])
    let s7 = ""
    h.assert_true(ConstantTimeCompare(s1, s1))
    h.assert_false(ConstantTimeCompare(s1, s2))
    h.assert_false(ConstantTimeCompare(s1, s3))
    h.assert_false(ConstantTimeCompare(s1, s4))
    h.assert_false(ConstantTimeCompare(s1, s5))
    h.assert_true(ConstantTimeCompare(s5, s6))
    h.assert_false(ConstantTimeCompare(s1, s6))
    h.assert_false(ConstantTimeCompare(s1, s7))

interface _TestHashFn
  """
  Produces a fixed-length byte array based on the input sequence.
  """
  fun tag apply(input: ByteSeq): Array[U8] val
  new tag create()

class iso _TestHash[A: _TestHashFn] is UnitTest
  let _name: String
  let input: String
  let assert: String
  
  new iso create(name': String, input': String, assert': String)
  =>
    _name = "crypto/Hash/"+ name'.upper()
    input = input'
    assert = assert'
    
  fun name(): String => _name

  fun apply(h: TestHelper) =>
    h.assert_eq[String](
      assert,
      ToHexString(A(input)))

class iso _TestDigest is UnitTest
  let _name: String
  let d: (Digest | None)
  let inputs: Array[String] val
  let assert: String
  
  new iso create(name': String,
    inputs': Array[String] val, assert': String)
  =>
    _name = "crypto/Digest/"+ name'.upper()
    d =
      match name'.lower()
      | "md4" => Digest.md4()
      | "md5" => Digest.md5()
      | "ripemd160" => Digest.ripemd160()
      | "sha1" => Digest.sha1()
      | "sha224" => Digest.sha224()
      | "sha256" => Digest.sha256()
      | "sha384" => Digest.sha384()
      | "sha512" => Digest.sha512()
      end
      ifdef "openssl_1.1.x" then
        match name'.lower()
        | "shake128" => Digest.shake128()
        | "shake256" => Digest.shake256()
      end  
      inputs = inputs'
      assert = assert'
    
  fun name(): String => _name

  fun ref apply(h: TestHelper)? =>
    for input in inputs.values() do
      (d as Digest).append(input)?
    end
    h.assert_eq[String](assert, ToHexString((d as Digest).final()))
