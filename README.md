# SHA256-Powershell
There is plenty of documentation out there on how to create MD5/SHA256 sums with powershell, but not a lot on how to verify a single sum and just about nothing on multiple checksums with powershell. I found [this](https://www.hexnode.com/mobile-device-management/help/powershell-script-to-verify-the-file-hash-of-a-file-on-windows-devices/) for a single checksum in powershell and made it recursively check against a file named `SHA256` or `MD5` depending on the version used.  

To make a *nix/PS friendly SHA256 sum on *nix execute
```
find -type f \( -not -name "SHA256" \) -exec sha256sum '{}' \; > SHA256 && sed 's/[.][/]//1' -i SHA256
```
