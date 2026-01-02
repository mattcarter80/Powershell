<#
    Script;
        Uses hashed credentials to connect to server, then adds AD group to Administrators
        ** Existing admin credentials to be used **
#>

# Run below command to create password object
Read-Host -AsSecureString "<Profile>" | ConvertFrom-SecureString | Out-File "<FileLocationForOutput>.txt"

# Use Credential Object in Script
$ProfilePassword = Get-Content "<FileLocationForOutput>.txt" | ConvertTo-SecureString
$ProfileCredential = New-Object -TypeName System.Management.Automation.PSCredential -ArgumentList "Domain\Profile",$ProfilePassword

# Specify Servers where AD Group needs to be added
$Servers = @("Server1","Server2")

ForEach ($Server in $Servers) {
    Invoke-Command -ComputerName $Servers -Credential $ProfileCredential -ScriptBlock {
        Add-LocalGroupMember -Group "Administrators" -Member "<ADGroup>" -ErrorAction SilentlyContinue
    }
}