$homeDir = (Resolve-Path "$PSScriptRoot\..").Path

$tirchocotest = @{
    targetFolder = "$homeDir\target"
    artifactsFolder = "$homeDir\artifacts"
    releaseNotePath = "$homeDir\RELEASENOTE.md"
    releaseFolder = "$homeDir\target\Release\TirChocoTestApp"
    assetZipPath = "$homeDir\artifacts\tools-win-x64.zip"
}

$choco = @{
    homeDir = "$homeDir\src\nuspec\chocolatey"
    nuspec = "$homeDir\src\nuspec\chocolatey\tirchocotest.nuspec"
    chocoScript = "$homeDir\src\nuspec\chocolatey\tools\chocolateyinstall.ps1"
}
