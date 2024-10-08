# Verify Checksums in Powershell
There is plenty of documentation out there on how to create MD5/SHA256 sums with powershell, but not a lot on how to verify a single sum and just about nothing on multiple or recursive checksums with powershell. I found [this](https://www.hexnode.com/mobile-device-management/help/powershell-script-to-verify-the-file-hash-of-a-file-on-windows-devices/) for a single checksum in powershell and made it recursively check against a file named `SHA256` or `MD5` depending on the version used.  

The batch script is untested, the powershell scripts were tested with powershell for linux and still needs windows machine testing.

---

# Create Checksums in Powershell
To produce a `sha256sum/md5sum -c` and powershell compatible checksum file in powershell I created `SHA256GEN/MD5GEN.ps1` scripts for that. Make sure you run the script inside the directory you want to recursively generate checksums for and will generate a file in that directory named `SHA256` or `MD5` with the checksums in a hash > file format.

On *nix to make a *nix/PS friendly SHA256 sum on *nix execute
```
find -type f \( -not -name "SHA256" \) -exec sha256sum '{}' \; > SHA256 && sed 's/[.][/]//1' -i SHA256
```
For md5
```
find -type f \( -not -name "MD5" \) -exec md5sum '{}' \; > MD5 && sed 's/[.][/]//1' -i MD5
```
