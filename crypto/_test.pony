use "pony_test"

actor \nodoc\ Main is TestList
  new create(env: Env) => PonyTest(env, this)
  new make() => None

  fun tag tests(test: PonyTest) =>
    test(_TestConstantTimeCompare)
    test(_TestMD4)
    test(_TestMD5)
    test(_TestRIPEMD160)
    test(_TestSHA1)
    test(_TestSHA224)
    test(_TestSHA256)
    test(_TestSHA384)
    test(_TestSHA512)
    test(_TestDigest)

class \nodoc\ iso _TestConstantTimeCompare is UnitTest
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

class \nodoc\ iso _TestMD4 is UnitTest
  fun name(): String => "crypto/MD4"

  fun apply(h: TestHelper) =>
    h.assert_eq[String](
      "db346d691d7acc4dc2625db19f9e3f52",
      ToHexString(MD4("test")))

class \nodoc\ iso _TestMD5 is UnitTest
  fun name(): String => "crypto/MD5"

  fun apply(h: TestHelper) =>
    h.assert_eq[String](
      "098f6bcd4621d373cade4e832627b4f6",
      ToHexString(MD5("test")))

class \nodoc\ iso _TestRIPEMD160 is UnitTest
  fun name(): String => "crypto/RIPEMD160"

  fun apply(h: TestHelper) =>
    h.assert_eq[String](
      "5e52fee47e6b070565f74372468cdc699de89107",
      ToHexString(RIPEMD160("test")))

class \nodoc\ iso _TestSHA1 is UnitTest
  fun name(): String => "crypto/SHA1"

  fun apply(h: TestHelper) =>
    h.assert_eq[String](
      "a94a8fe5ccb19ba61c4c0873d391e987982fbbd3",
      ToHexString(SHA1("test")))

class \nodoc\ iso _TestSHA224 is UnitTest
  fun name(): String => "crypto/SHA224"

  fun apply(h: TestHelper) =>
    h.assert_eq[String](
      "90a3ed9e32b2aaf4c61c410eb925426119e1a9dc53d4286ade99a809",
      ToHexString(SHA224("test")))

class \nodoc\ iso _TestSHA256 is UnitTest
  fun name(): String => "crypto/SHA256"

  fun apply(h: TestHelper) =>
    h.assert_eq[String](
      "9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08",
      ToHexString(SHA256("test")))

class \nodoc\ iso _TestSHA384 is UnitTest
  fun name(): String => "crypto/SHA384"

  fun apply(h: TestHelper) =>
    h.assert_eq[String](
      "768412320f7b0aa5812fce428dc4706b3cae50e02a64caa16a782249bfe8efc4" +
      "b7ef1ccb126255d196047dfedf17a0a9",
      ToHexString(SHA384("test")))

class \nodoc\ iso _TestSHA512 is UnitTest
  fun name(): String => "crypto/SHA512"

  fun apply(h: TestHelper) =>
    h.assert_eq[String](
      "ee26b0dd4af7e749aa1a8ee3c10ae9923f618980772e473f8819a5d4940e0db2" +
      "7ac185f8a0e1d5f84f88bc887fd67b143732c304cc5fa9ad8e6f57f50028a8ff",
      ToHexString(SHA512("test")))

class \nodoc\ iso _TestDigest is UnitTest
  fun name(): String => "crypto/Digest"

  fun apply(h: TestHelper) ? =>
    let md5 = Digest.md5()
    md5.append("message1")?
    md5.append("message2")?
    h.assert_eq[String](
      "94af09c09bb9bb7b5c94fec6e6121482",
      ToHexString(md5.final()))

    let sha1 = Digest.sha1()
    sha1.append("message1")?
    sha1.append("message2")?
    h.assert_eq[String](
      "942682e2e49f37b4b224fc1aec1a53a25967e7e0",
      ToHexString(sha1.final()))

    let sha224 = Digest.sha224()
    sha224.append("message1")?
    sha224.append("message2")?
    h.assert_eq[String](
      "fbba013f116e8b09b044b2a785ed7fb6a65ce672d724c1fb20500d45",
      ToHexString(sha224.final()))

    let sha256 = Digest.sha256()
    sha256.append("message1")?
    sha256.append("message2")?
    h.assert_eq[String](
      "68d9b867db4bde630f3c96270b2320a31a72aafbc39997eb2bc9cf2da21e5213",
      ToHexString(sha256.final()))

    let sha384 = Digest.sha384()
    sha384.append("message1")?
    sha384.append("message2")?
    h.assert_eq[String](
      "7736dd67494a7072bf255852bd327406b398cb0b16cb400fcd3fcfb6827d74ab"+
      "9b14673d50515b6273ef15543325f8d3",
      ToHexString(sha384.final()))

    let sha512 = Digest.sha512()
    sha512.append("message1")?
    sha512.append("message2")?
    h.assert_eq[String](
      "3511f4825021a90cd55d37db5c3250e6bbcffc9a0d56d88b4e2878ac5b094692"+
      "cd945c6a77006272322f911c9be31fa970043daa4b61cee607566cbfa2c69b09",
      ToHexString(sha512.final()))

    ifdef "openssl_1.1.x" or "openssl_3.0.x" then
      let shake128 = Digest.shake128()
      shake128.append("message1")?
      shake128.append("message2")?
      h.assert_eq[String](
      "0d11671f23b6356bdf4ba8dcae37419d",
      ToHexString(shake128.final()))

      let shake256 = Digest.shake256()
      shake256.append("message1")?
      shake256.append("message2")?
      h.assert_eq[String](
      "80e2bbb14639e3b1fc1df80b47b67fb518b0ed26a1caddfa10d68f7992c33820",
      ToHexString(shake256.final()))
    end
