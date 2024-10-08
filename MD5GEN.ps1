$outputFile = "MD5"
$currentDirectory = Get-Location

Write-Host "Clearing or generating the output hash file"
Clear-Content $outputFile -ErrorAction SilentlyContinue

New-Item -ItemType File -Path $outputFile -Force | Out-Null
Write-Host "Generating hashes..."

Get-ChildItem -File -Recurse | ForEach-Object {
    $hash = Get-FileHash -Algorithm MD5 -Path $_.FullName
    $relativePath = $_.FullName.Substring($currentDirectory.Path.Length + 1)
    "$($hash.Hash)  $relativePath" | Out-File -FilePath $outputFile -Append
}

Write-Host "MD5 checksums generated and saved to '$outputFile'."
