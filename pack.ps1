param(
    [Parameter(Mandatory=$true)]
    [string]$Version
)

$ErrorActionPreference = "Stop"

$Output = "OreUI-Theme-MC1.12.2-${Version}.zip"
$TempDir = ".pack-temp"

Write-Host "Packing OreUI-Theme ${Version}..."

if (Test-Path $TempDir) { Remove-Item -Recurse -Force $TempDir }

New-Item -ItemType Directory -Path $TempDir -Force | Out-Null
Copy-Item -Recurse "assets" "${TempDir}/"
Copy-Item "pack.png" "${TempDir}/"
Copy-Item "pack.mcmeta" "${TempDir}/"

Compress-Archive -Path "${TempDir}/*" -DestinationPath $Output -Force

Remove-Item -Recurse -Force $TempDir

Write-Host "Done! Output: ${Output}"
