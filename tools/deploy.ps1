param(
    [switch] $main = $false,
    [ValidateSet('build', 'pack', 'release')]
    [string[]] $targets = 'build'
)

$ErrorActionPreference = "Stop"

. "$PSScriptRoot\config.ps1"
. "$PSScriptRoot\deploy-tasks.ps1"
. "$homeDir\common.ps1"

# Validate if tools are installed
$gitCommand = "git"
$chocoCommand = "choco"
$gitCommand,$chocoCommand | Foreach-Object {
    if (-not (ValidateCommand $_)) {
        ProcessLastExitCode 1 "$_ is required however it is not installed."
    }
}
$nugetCommand = GetNuGetCommandWithValidation $(GetOperatingSystemName) $true

Write-Host $($targets -join ",")
# Run release tasks
try {
    switch ($targets) {
        "build" {
            # Remove artifact folder and target folder if exist
            RemovePath $tirchocotest.targetFolder,$tirchocotest.artifactsFolder
            # Run build.ps1
            $buildScriptPath = (Resolve-Path "$homeDir\build.ps1").Path
            if ($main) {
                & $buildScriptPath -prod -release
            } else {
                & $buildScriptPath -prod
            }  
        }
        "pack" {
            $packScriptPath = (Resolve-Path "$homeDir\pack.ps1").Path
            & $packScriptPath
        }
        "release" {
            if ($main) {
                if (IsReleaseNoteVersionChanged $gitCommand $tirchocotest.releaseNotePath) 
                {
                    PackAssetZip $tirchocotest.releaseFolder $tirchocotest.assetZipPath
                    
                    # TODO: later publish to nuget as well
                    #PublishToNuget $nugetCommand $nuget."nuget.org" $tirchocotest.artifactsFolder $env:NUGETAPIKEY
                    
                    # TODO: revisit for publish to release
                    #PublishToGithub $tirchocotest.assetZipPath $tirchocotest.releaseNotePath $tirchocotest.sshRepoUrl $env:TOKEN
                    
                    PublishToChocolatey $chocoCommand $tirchocotest.releaseNotePath $tirchocotest.assetZipPath $choco.chocoScript $choco.nuspec $choco.homeDir $env:CHOCO_TOKEN
                } else {
                    Write-Host "`$releaseNotePath $($tirchocotest.releaseNotePath) hasn't been changed. Ignore to publish package." -ForegroundColor Yellow
                }
            }
        }
    }
} catch {   
    ProcessLastExitCode 1 "Process failed: $_"
}