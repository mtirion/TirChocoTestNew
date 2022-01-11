dotnet publish TirChocoTestApp -c Release -r win-x64 /p:PublishSingleFile=true /p:CopyOutputSymbolsToPublishDirectory=false /p:GenerateDocumentationFile=false --self-contained false -o ./output/win-x64

dotnet publish TirChocoTestApp -c Release -r linux-x64 /p:PublishSingleFile=true /p:CopyOutputSymbolsToPublishDirectory=false /p:GenerateDocumentationFile=false --self-contained true /p:PublishTrimmed=false -o ./output/linux-x64
