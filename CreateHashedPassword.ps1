<#
    Script;
        Creates a hashed out password for use in scripts
        Used to traverse network to / from DMZ machines
#>

# Run below command to create password object
Read-Host -AsSecureString "<Profile>" | ConvertFrom-SecureString | Out-File "<FileLocationForOutput>.txt"

# Use Credential Object in Script
$ProfilePassword = Get-Content "<FileLocationForOutput>.txt" | ConvertTo-SecureString
$ProfileCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "Domain\Profile",$ProfilePassword

# Example of use below to map drive
New-PSDrive -PSProvider FileSystem -Name <DriveLetterToMap> -root "<NetworkLocationMappingTo>" -Credential $ProfileCredential