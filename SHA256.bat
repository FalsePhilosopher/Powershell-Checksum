@echo off
setlocal enabledelayedexpansion

:: Define the file that contains the pre-generated SHA256 checksums
set "checksum_file=SHA256"

:: Check if the checksum file exists
if not exist "%checksum_file%" (
    echo Checksum file "%checksum_file%" not found!
    exit /b 1
)

echo Verifying SHA256 checksums...

:: Read each line of the checksum file
for /f "tokens=1,*" %%A in (%checksum_file%) do (
    set "expected_hash=%%A"
    set "relative_path=%%B"
    
    :: Check if the file exists
    if not exist "!relative_path!" (
        echo ERROR: File "!relative_path!" not found!
        exit /b 1
    )
    
    :: Calculate the SHA256 hash of the file using CertUtil
    for /f "tokens=*" %%H in ('certutil -hashfile "!relative_path!" SHA256 ^| findstr /v "hash of"') do (
        set "actual_hash=%%H"
    )

    :: Compare the actual hash with the expected hash
    if /i "!expected_hash!" neq "!actual_hash!" (
        echo ERROR: Hash mismatch for file "!relative_path!"
        echo Expected: !expected_hash!
        echo Actual:   !actual_hash!
        exit /b 1
    )
)

echo All files verified successfully.
exit /b 0
