$ErrorActionPreference = 'Stop';

$packageName= 'TirChocoTestNew'
$version    = 'v0.4.0.0'
$toolsDir   = "$(Split-Path -parent $MyInvocation.MyCommand.Definition)"
$url        = "https://github.com/mtirion/tirchoctestnew/releases/download/$version/tools-win-x64.zip"
$hash       = '12345678901234567890'

$packageArgs = @{
  packageName   = $packageName
  unzipLocation = $toolsDir
  url           = $url
  checksum      = $hash
  checksumType  = 'SHA256'
}

Install-ChocolateyZipPackage @packageArgs
