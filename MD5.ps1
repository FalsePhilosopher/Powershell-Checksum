# Get the current directory (where the script is executed from)
$directoryPath = (Get-Location).Path

# Hash file path (file is named "MD5" without extension)
$hashFilePath = Join-Path $directoryPath "MD5"

# Function to compute MD5 hash for a file
function Get-MD5Hash($file) {
    $md5 = [System.Security.Cryptography.MD5]::Create()
    $stream = [System.IO.File]::OpenRead($file)
    $hash = [BitConverter]::ToString($md5.ComputeHash($stream)).Replace("-", "").ToLower()
    $stream.Close()
    return $hash
}

# Check if the hash file named 'MD5' exists
if (-Not (Test-Path $hashFilePath)) {
    Write-Host "Hash file 'MD5' not found in $directoryPath."
    exit
}

# Load the hash file, assuming it contains lines with the format: "<hash> <filename>"
$hashDictionary = @{}
Get-Content $hashFilePath | ForEach-Object {
    # Split each line into hash and filename
    $lineParts = $_ -split ' ', 2
    if ($lineParts.Length -eq 2) {
        $hash = $lineParts[0].Trim()
        $file = $lineParts[1].Trim()
        $hashDictionary[$file] = $hash
    }
}

# Recursively get all files in the current directory
Get-ChildItem -Path $directoryPath -File -Recurse | ForEach-Object {
    $filePath = $_.FullName
    $relativeFilePath = $_.FullName.Substring($directoryPath.Length + 1) # Get file path relative to the current directory

    if ($hashDictionary.ContainsKey($relativeFilePath)) {
        $expectedMD5 = $hashDictionary[$relativeFilePath]
        $md5Hash = Get-MD5Hash $filePath

        if ($md5Hash -eq $expectedMD5) {
            Write-Host "File '$relativeFilePath' is authentic."
        } else {
            Write-Host "File '$relativeFilePath' may have been tampered with!"
            Write-Host "MD5 Hash: $md5Hash"
        }
    } else {
        Write-Host "No hash entry found for file '$relativeFilePath' in the hash file."
    }
}

echo "All Ok" || echo "Something's fishy"
