param([string] $configuration = "Release")

# Include
$scriptRoot = $($MyInvocation.MyCommand.Definition) | Split-Path
. "$scriptRoot/common.ps1"

$ErrorActionPreference = 'Stop'
$packageVersionFilePath = ".\package_version_temp.txt" # build.ps1 saves the package version to this temp file

if (Test-Path $packageVersionFilePath){
    $packageVersion = Get-Content -Path $packageVersionFilePath
    Write-Host "Package version: $packageVersion"
}
else{
    ProcessLastExitCode 1 "$packageVersionFilePath is not found. Please run build.ps1 to generate the file."
}

$os = GetOperatingSystemName
Write-Host "Running on OS $os"
$nugetCommand = GetNuGetCommandWithValidation ($os) ($true)
$scriptPath = $MyInvocation.MyCommand.Path
$scriptHome = Split-Path $scriptPath

$global:LASTEXITCODE = $null

Push-Location $scriptHome

function NugetPack {
    param($basepath, $nuspec, $version)
    if (Test-Path $nuspec) {
        & $nugetCommand pack $nuspec -Version $version -OutputDirectory artifacts/$configuration -BasePath $basepath
        ProcessLastExitCode $lastexitcode "$nugetCommand pack $nuspec -Version $version -OutputDirectory artifacts/$configuration -BasePath $basepath"
    }
}

# Check if dotnet cli exists globally
if (-not(ValidateCommand("dotnet"))) {
    ProcessLastExitCode 1 "Dotnet CLI is not successfully configured. Please follow https://www.microsoft.com/net/core to install .NET Core."
}

Copy-Item -Path "LICENSE" -Destination $docfxTarget -Force

Write-Host "Pack succeeds." -ForegroundColor Green
Pop-Location