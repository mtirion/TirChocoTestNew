param(
    [string] $configuration = "Release",
    [switch] $prod = $false,
    [switch] $skipTests = $false,
    [switch] $release = $false
)
################################################################################################
# Usage:
# Run build.ps1
#   [-configuration Configuration]: Default to be Release
#   [-prod]: If it's set, the build process will update version
#   [-skipTests]: If it's set, running unit tests will be skipped
################################################################################################

# Include
$scriptRoot = $($MyInvocation.MyCommand.Definition) | Split-Path
. "$scriptRoot/tools/common.ps1"

$ErrorActionPreference = 'Stop'
$releaseBranch = "main"
$gitCommand = "git"
$packageVersion = "1.0.0"

$os = GetOperatingSystemName
Write-Host "Running on OS $os"
$scriptPath = $MyInvocation.MyCommand.Path
$scriptHome = Split-Path $scriptPath

$global:LASTEXITCODE = $null

Push-Location $scriptHome

# Check if dotnet cli exists globally
if (-not(ValidateCommand("dotnet"))) {
    ProcessLastExitCode 1 "Dotnet CLI is not successfully configured. Please follow https://www.microsoft.com/net/core to install .NET Core."
}

if ($prod -eq $true) {
    Write-Host "Updating version from ReleaseNote.md and GIT commit info"

    if (-not(ValidateCommand($gitCommand))) {
        ProcessLastExitCode 1 "Git is required however it is not installed."
    }

    if ($release -eq $false) {
        $branch = & $gitCommand rev-parse --abbrev-ref HEAD
        ProcessLastExitCode $lastexitcode "Get GIT branch name $branch"
    }
    else {
        $branch = "main";
        Write-Host "Release version using $branch branch"
    }

    $version = "v1", "0", "0"

    $firstLine = Get-Content ReleaseNote.md | Select-Object -First 1
    if ($firstLine -match ".*(v[0-9.]+)") {
        $mainVersion = ($matches[1] -split '\.')
        for ($i = 0; $i -lt $mainVersion.length -and $i -lt 3; $i++) {
            $version[$i] = $mainVersion[$i]
        }
    }

    $commitInfo = (& $gitCommand describe --tags) -split '-'
    ProcessLastExitCode $lastexitcode "Get GIT commit information $commitInfo"

    Write-Host "CommitInfo: $commitInfo"

    if ($commitInfo.length -gt 1) {
        $revision = (Get-Date -UFormat "%Y%m%d").Substring(2) + $commitInfo[1].PadLeft(3, '0')
    }
    else {
        $revision = '000000000'
    }

    if ($branch -ne $releaseBranch) {
        $abbrev = $commitInfo[2].Substring(0, 7)
        $packageVersion = ((($version -join '.'), "b", $revision, $abbrev) -join '-').Substring(1)
    }
    else {
        $packageVersion = ($version -join ".").Substring(1)
    }
}

$packageVersionFilePath = ".\package_version_temp.txt"
$packageVersion | Out-File -FilePath $packageVersionFilePath -Force
Write-Host "Package version saved to $packageVersionFilePath"

$sln = Get-Item -Path .\src\TirChocoTestApp\TirChocoTestApp.sln
Write-Host "Start building $($sln.FullName)"

& dotnet restore $sln.FullName /p:Version=$packageVersion
ProcessLastExitCode $lastexitcode "dotnet restore $($sln.FullName) /p:Version=$packageVersion"

& dotnet build $sln.FullName -c $configuration -v n /m:1
ProcessLastExitCode $lastexitcode "dotnet build $($sln.FullName) -c $configuration -v n /m:1"

$name = "TirChocoTestApp"
$outputFolder = "$scriptHome/target/$configuration/$name"
# publish to target folder
& dotnet publish src\TirChocoTestApp -c $configuration -r win-x64 /p:PublishSingleFile=true /p:CopyOutputSymbolsToPublishDirectory=false /p:GenerateDocumentationFile=false --self-contained false -o $outputFolder
ProcessLastExitCode $lastexitcode "dotnet publish src\TirChocoTestApp -c $configuration -r win-x64 /p:PublishSingleFile=true /p:CopyOutputSymbolsToPublishDirectory=false /p:GenerateDocumentationFile=false --self-contained false -o $outputFolder"

Write-Host "Build succeeds." -ForegroundColor Green
Pop-Location


