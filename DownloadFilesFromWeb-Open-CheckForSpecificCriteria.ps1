<#
    Script;
        **  Pre-Requisites: Powershell Module 7Zip4Powershell to be downloaded from https://www.powershellgallery.com/packages/7Zip4Powershell/2.0.0 and added to location defined at $env:PSModulePath
            Account able to open file required 
            Uses hashed Password **
            Creates 128bit Passkey - This group of commands only needs to be run once
            Imports Powershell Module
            Creates a PassKey for use with certificate (if required)
            Specifies criteria to use for Powershell 5 or Powershell 7, depending on version
            Downloads Zip files
            Opens Zip file using hashed credentials
            Checks file content for specific criteria
            Sends email if specific criteria not found
            Clears up 'old' files
#>

<#
# Create Passkey
$File = "<Path where hashed credential will be stored>"
[Byte[]] $Key = (1..16)
$Password = "<Enter desired password here>" | ConvertTo-SecureString -AsPlainText -Force
#>

# Import Module
Import-Module -Name 7Zip4Powershell

# Create variables as defined in known file output
$Date = Get-Date -Format "yyyyMMdd" # This is to be used in the later search to be run
[Byte[]] $Key = (1..16) # Secure Key for Download
$Password = Get-Content -Path "<Path to Hashed Credential>" | ConvertTo-SecureString -Key $KEY

# Use this section if running Powershell 5 and the Website you are downloading from is https
add-type @"
using System.Net
using System.Security.Cryptography.X509Certificates;
public Class TrustAllCertsPolicy : ICertificatePolicy {
    public bool CheckValidationResult(
        ServicePoint srvPoint, X509Certificate certificate,
        WebRequest request, int certificateProblem) {
            return true;
            }
    }
"@ 
[System.Net.ServicePointManager]::CertificatePolicy = New-Object TrustAllCertsPolicy

Invoke-WebRequest -Uri "https://website.com/directory/zipfile.zip" -OutFile "<File Location for Download>"

# Use line below if you are running Powershell 7 and the Website you are downloading from is https, ignoring lines 32-46 above, inclusive
Invoke-WebRequest -Uri "https://website.com/directory/zipfile.zip" -SkipCertificateCheck -OutFile "<File Location for Download>"

# Use the below line if teh website is http, ignoring lines 32-49 above, inclusive
Invoke-WebRequest -Uri "http://website.com/directory/zipfile.zip" -OutFile "<File Location for Download>"

# Expand Zip File
Expand-7Zip -ArchiveFileName "<File Location for Download>" -TargetPath "<File Location for Expanded File - Use variables defined above if required, such as $Date>" -SecurePassword ($Password)

#Search for File Content and Perform Count
(Get-Content -Path "<File Location for Expanded File>" | Select-String -Pattern "<SearchString>" | Sort-Object -Unique | Measure-Object).Count

# Send Mail if count above if zero
if ((Get-Content -Path "File Location for Expanded File" | Select-String -Pattern "<SearchString>" | Sort-Object -Unique | Measure-Object).Count -eq '0') {
    Send-MailMessage -From "<FromAddress>" -To "<ToAddress>" -Subject "<Subject>" -SmtpServer "<SmtpServer>"
}

# Clean Up Historic Files
$Path = "<FileLocationSpecifiedAbove>"
$DaysBack = "-<DaysToDeleteOlderThan>"
$CurrentDate = Get-Date -format "yyyy-mm-dd"
$DateToDelete = ((Get-Date).AddDays($DaysBack)).ToString("yyyy-MM-dd")

Get-ChildItem $Path -Recurse -Include "*.<FileExtension>" | Where-Object {($_.LastWriteTime -lt $DateToDelete)} | Remove-Item