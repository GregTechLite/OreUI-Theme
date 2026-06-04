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

if (Test-Path $Output) { Remove-Item $Output }

[System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression') | Out-Null
[System.Reflection.Assembly]::LoadWithPartialName('System.IO.Compression.FileSystem') | Out-Null

$archive = [System.IO.Compression.ZipFile]::Open($Output, 1)
$tempBase = (Resolve-Path $TempDir).Path

Get-ChildItem -Recurse -File $TempDir | ForEach-Object {
    $relativePath = ($_.FullName.Substring($tempBase.Length + 1) -replace '\\', '/')
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($archive, $_.FullName, $relativePath) | Out-Null
}

Get-ChildItem -Recurse -Directory $TempDir | ForEach-Object {
    $relativePath = ($_.FullName.Substring($tempBase.Length + 1) -replace '\\', '/') + '/'
    $archive.CreateEntry($relativePath) | Out-Null
}

$archive.Dispose()

Remove-Item -Recurse -Force $TempDir

Write-Host "Done! Output: ${Output}"
