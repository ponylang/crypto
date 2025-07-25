Param(
  [Parameter(Position=0, HelpMessage="The action to take (build, test, install, package, clean).")]
  [string]
  $Command = 'build',

  [Parameter(HelpMessage="The build configuration (Release, Debug).")]
  [string]
  $Config = "Release",

  [Parameter(HelpMessage="The version number to set.")]
  [string]
  $Version = "",

  [Parameter(HelpMessage="Architecture (native, x64).")]
  [string]
  $Arch = [System.Runtime.InteropServices.RuntimeInformation]::OSArchitecture,

  [Parameter(HelpMessage="Directory to install to.")]
  [string]
  $Destdir = "build/install"
)

$ErrorActionPreference = "Stop"

$target = "crypto" # The name of the source package, and the base name of the .exe file that is built if this is a program, not a library.
$testPath = "." # The path of the tests package relative to the $target directory.
$isLibrary = $true

$rootDir = Split-Path $script:MyInvocation.MyCommand.Path
$srcDir = Join-Path -Path $rootDir -ChildPath $target


if ($Arch -ieq 'x64')
{
  $Arch = 'x86-64'
}
elseif ($Arch -ieq 'arm64')
{
  $Arch = 'arm64'
}

$Thost = "x64"
if ($Arch -ieq "arm64")
{
    # if this is lowercase arm64, then things go boom.
    $Thost = "ARM64"
}

if ($Config -ieq "Release")
{
  $configFlag = ""
  $buildDir = Join-Path -Path $rootDir -ChildPath "build/release"
}
elseif ($Config -ieq "Debug")
{
  $configFlag = "--debug"
  $buildDir = Join-Path -Path $rootDir -ChildPath "build/debug"
}
else
{
  throw "Invalid -Config path '$Config'; must be one of (Debug, Release)."
}

$libsDir = Join-Path -Path $rootDir -ChildPath "build/libs"

if (($Version -eq "") -and (Test-Path -Path "$rootDir\VERSION"))
{
  $Version = (Get-Content "$rootDir\VERSION") + "-" + (& git 'rev-parse' '--short' '--verify' 'HEAD^')
}

$ponyArgs = "--define openssl_0.9.0 --path $rootDir"

Write-Host "Configuration:    $Config"
Write-Host "Version:          $Version"
Write-Host "Root directory:   $rootDir"
Write-Host "Source directory: $srcDir"
Write-Host "Build directory:  $buildDir"

# generate pony templated files if necessary
if (($Command -ne "clean") -and (Test-Path -Path "$rootDir\VERSION"))
{
  $versionTimestamp = (Get-ChildItem -Path "$rootDir\VERSION").LastWriteTimeUtc
  Get-ChildItem -Path $srcDir -Include "*.pony.in" -Recurse | ForEach-Object {
    $templateFile = $_.FullName
    $ponyFile = $templateFile.Substring(0, $templateFile.Length - 3)
    $ponyFileTimestamp = [DateTime]::MinValue
    if (Test-Path $ponyFile)
    {
      $ponyFileTimestamp = (Get-ChildItem -Path $ponyFile).LastWriteTimeUtc
    }
    if (($ponyFileTimestamp -lt $versionTimestamp) -or ($ponyFileTimestamp -lt $_.LastWriteTimeUtc))
    {
      Write-Host "$templateFile -> $ponyFile"
      ((Get-Content -Path $templateFile) -replace '%%VERSION%%', $Version) | Set-Content -Path $ponyFile
    }
  }
}

function BuildTarget
{
  $binaryFile = Join-Path -Path $buildDir -ChildPath "$target.exe"
  $binaryTimestamp = [DateTime]::MinValue
  if (Test-Path $binaryFile)
  {
    $binaryTimestamp = (Get-ChildItem -Path $binaryFile).LastWriteTimeUtc
  }

  :buildFiles foreach ($file in (Get-ChildItem -Path $srcDir -Include "*.pony" -Recurse))
  {
    if ($binaryTimestamp -lt $file.LastWriteTimeUtc)
    {
      Write-Host "corral fetch"
      $output = (corral fetch)
      $output | ForEach-Object { Write-Host $_ }
      if ($LastExitCode -ne 0) { throw "Error" }

      Write-Host "corral run -- ponyc $configFlag $ponyArgs --output `"$buildDir`" `"$srcDir`""
      $output = (corral run -- ponyc $configFlag $ponyArgs --output "$buildDir" "$srcDir")
      $output | ForEach-Object { Write-Host $_ }
      if ($LastExitCode -ne 0) { throw "Error" }
      break buildFiles
    }
  }
}

function BuildTest
{
  $testTarget = "test.exe"
  if ($testPath -eq ".")
  {
    $testTarget = "$target.exe"
  }

  $testFile = Join-Path -Path $buildDir -ChildPath $testTarget
  $testTimestamp = [DateTime]::MinValue
  if (Test-Path $testFile)
  {
    $testTimestamp = (Get-ChildItem -Path $testFile).LastWriteTimeUtc
  }

  :testFiles foreach ($file in (Get-ChildItem -Path $srcDir -Include "*.pony" -Recurse))
  {
    if ($testTimestamp -lt $file.LastWriteTimeUtc)
    {
      Write-Host "corral fetch"
      $output = (corral fetch)
      $output | ForEach-Object { Write-Host $_ }
      if ($LastExitCode -ne 0) { throw "Error" }

      $testDir = Join-Path -Path $srcDir -ChildPath $testPath
      Write-Host "corral run -- ponyc $configFlag $ponyArgs --output `"$buildDir`" `"$testDir`""
      $output = (corral run -- ponyc $configFlag $ponyArgs --output "$buildDir" "$testDir")
      $output | ForEach-Object { Write-Host $_ }
      if ($LastExitCode -ne 0) { throw "Error" }
      break testFiles
    }
  }

  Write-Output "$testTarget.exe is built" # force function to return a list of outputs
  return $testFile
}

function BuildLibs
{
  $libreSsl = "libressl-3.9.1"

  if (-not (Test-Path "$rootDir/crypto.lib"))
  {
    $libreSslSrc = Join-Path -Path $libsDir -ChildPath $libreSsl

    if (-not (Test-Path $libreSslSrc))
    {
      $libreSslTgz = "$libreSsl.tar.gz"
      $libreSslTgzTgt = Join-Path -Path $libsDir -ChildPath $libreSslTgz
      if (-not (Test-Path $libreSslTgzTgt)) { Invoke-WebRequest -TimeoutSec 300 -Uri "https://cdn.openbsd.org/pub/OpenBSD/LibreSSL/$libreSslTgz" -OutFile $libreSslTgzTgt }
      tar -xvzf "$libreSslTgzTgt" -C "$libsDir"
      if ($LastExitCode -ne 0) { throw "Error downloading and extracting $libreSslTgz" }
    }

    # Write-Output "Building $libreSsl"
    $libreSslLib = Join-Path -Path $libsDir -ChildPath "lib/ssl-48.lib"

    if (-not (Test-Path $libreSslLib))
    {
      Push-Location $libreSslSrc
      (Get-Content "$libreSslSrc\CMakeLists.txt").replace('add_definitions(-Dinline=__inline)', "add_definitions(-Dinline=__inline)`nadd_definitions(-DPATH_MAX=255)") | Set-Content "$libreSslSrc\CMakeLists.txt"
      cmake.exe $libreSslSrc -Thost="$Thost" -A "$THost" -DCMAKE_INSTALL_PREFIX="$libsDir" -DCMAKE_BUILD_TYPE="Release"
      if ($LastExitCode -ne 0) { Pop-Location; throw "Error configuring $libreSsl" }
      cmake.exe --build . --target install --config Release
      if ($LastExitCode -ne 0) { Pop-Location; throw "Error building $libreSsl" }
      Pop-Location
    }

    # copy to the root dir (i.e. PONYPATH) for linking
    Copy-Item -Force -Path "$libsDir/lib/crypto.lib" -Destination "$rootDir/crypto.lib"
  }
}

switch ($Command.ToLower())
{
  "libs"
  {
    if (-not (Test-Path $libsDir))
    {
      mkdir "$libsDir"
    }

    BuildLibs
  }

  "build"
  {
    if (-not $isLibrary)
    {
      BuildTarget
    }
    else
    {
      Write-Host "$target is a library; nothing to build."
    }
    break
  }

  "test"
  {
    if (-not $isLibrary)
    {
      BuildTarget
    }

    $testFile = (BuildTest)[-1]
    Write-Host "$testFile"
    & "$testFile"
    if ($LastExitCode -ne 0) { throw "Error" }
    break
  }

  "clean"
  {
    if (Test-Path "$buildDir")
    {
      Write-Host "Remove-Item -Path `"$buildDir`" -Recurse -Force"
      Remove-Item -Path "$buildDir" -Recurse -Force
    }
    break
  }

  "distclean"
  {
    $distDir = Join-Path -Path $rootDir -ChildPath "build"
    if (Test-Path $distDir)
    {
      Remove-Item -Path $distDir -Recurse -Force
    }
    Remove-Item -Path "*.lib" -Force
  }

  "install"
  {
    if (-not $isLibrary)
    {
      $binDir = Join-Path -Path $Destdir -ChildPath "bin"

      if (-not (Test-Path $binDir))
      {
        mkdir "$binDir"
      }

      $binFile = Join-Path -Path $buildDir -ChildPath "$target.exe"
      Copy-Item -Path $binFile -Destination $binDir -Force
    }
    else
    {
      Write-Host "$target is a library; nothing to install."
    }
    break
  }

  "package"
  {
    if (-not $isLibrary)
    {
      $binDir = Join-Path -Path $Destdir -ChildPath "bin"
      $package = "$target-$Arch-pc-windows-msvc.zip"
      Write-Host "Creating $package..."

      Compress-Archive -Path $binDir -DestinationPath "$buildDir\..\$package" -Force
    }
    else
    {
      Write-Host "$target is a library; nothing to package."
    }
    break
  }

  default
  {
    throw "Unknown command '$Command'; must be one of (libs, build, test, install, package, clean, distclean)."
  }
}
