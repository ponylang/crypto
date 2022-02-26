## Update to work with ponytest name change in Pony 0.49.0

The Pony unit testing framework PonyTest had [its package name renamed](https://github.com/ponylang/ponyc/pull/4032) from `ponytest` to `pony_test` to match standard library naming conventions. We've updated to account for the new name.

## Updates for libs build on Windows

We removed a hard-coded Visual Studio version from the build script so that it can be built with more versions of Visual Studio.
We upgraded the LibreSSL version to 3.5.0.

