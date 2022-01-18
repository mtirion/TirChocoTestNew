param([string]$version="0.1.0.0")
Write-Output Building version $version

if (Test-Path -Path output) {
    Remove-Item output -recurse -force
}

dotnet publish src\TirChocoTestApp -c Release -r win-x64 /p:Version=$version /p:PublishSingleFile=true /p:CopyOutputSymbolsToPublishDirectory=false /p:GenerateDocumentationFile=false --self-contained false -o output/win
Copy-Item LICENSE output/win

dotnet publish src\TirChocoTestApp -c Release -r linux-x64 /p:Version=$version /p:PublishSingleFile=true /p:CopyOutputSymbolsToPublishDirectory=false /p:GenerateDocumentationFile=false --self-contained true -o output/linux
Copy-Item LICENSE output/linux