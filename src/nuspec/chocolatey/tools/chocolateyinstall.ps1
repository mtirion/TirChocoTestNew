$ErrorActionPreference = 'Stop';

$packageName= 'TirChocoTestNew'
$version    = '0.6.0'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = "https://github.com/mtirion/TirChocoTestNew/releases/download/$version/tools-win-x64.zip"
$hash       = 'fc3bb6ae9fb981ddc88e106c08f0aecfecf131a519e41b51c4a90db093f568a9'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url           = $url
  checksum      = $hash
  checksumType  = 'SHA256'
}

Install-ChocolateyZipPackage @packageArgs
