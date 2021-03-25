// in your code this `use` statement would be:
// use "crypto"
use "../../crypto"

actor Main
  new create(env: Env) =>
    let sha256digest: Digest = Digest.sha256()
    try
      sha256digest.append("Hello ")?
      sha256digest.append("World")?
      let hash: Array[U8] val = sha256digest.final()
      env.out.print("SHA256: " + ToHexString(hash))
    else
      env.out.print("Error computing hash")
    end
