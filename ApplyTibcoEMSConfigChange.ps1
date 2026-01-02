<#
    Script;
        ** Pre-Requisite: Tibco must be installed on the machine where this script is to run **
        Applies scripted config change to Tibco EMS instance running on Windows: 
        This script is specifically for Durables but can be edited to account for other static config held in tibemsd.json
#>

$ConfigSourceDirectory = "<Network Location>"
$ConfigDestinationDirectory = "<Local Drive on Host>"
$ReleaseId = "<Release Folder>"                                 # Change this per release
$Durables = "<Durable Name(s). Can be specified as an array>"   # Change this per release
$DurableConfigFromBackup = "$ConfigDestinationDirectory\$ReleaseId\Durables_Backup.csv"
$BackupConfig = Get-Content -Path "$ConfigDestinationDirectory\$ReleaseId\tibemsd.json" -Raw | ConvertFrom-Json
$Results = "$ConfigDestinationDirectory\$ReleaseId\Results.txt"
$ActiveConfig = Get-Config -Path "<Location where Production config will be for comparison>\tibemsd.json" -Raw | ConvertFrom-Json
$DurableConfigActive = "$ConfigDestinationDirectory\$ReleaseId\Durables_Active.csv"
$FormatEnumerationLimit = -1

# Copy Release from Network to Host
Get-ChildItem -Path "$ConfigSourceDirectory\$ReleaseId\" | Copy-Item -Destination "<Location on local host>" -Recurse

# Create Results File
New-Item -Path $Results -ItemType File -Force

# Extract Existing Durable Config
Add-Content -Path $Results -Value BEFORE:
$BackupConfigData = $BackupConfig
$BackupConfigData.durables | Export-Csv $DurableConfigFromBackup
Import-Csv $DurableConfigFromBackup | Select-Object -Property clientid,name,selector,topic | Select-String -Pattern $Durables | Out-File $Results -Append

# Deploy Change
Set-Location "<Location of Tibco Installation>"
.\tibemsadmin -server tcp://<emsinstance>:<port> -user <user> -password <password> -script "$ConfigDestinationDirectory\$ReleaseId\<Script>.txt" > "$ConfigDestinationDirectory\$ReleaseId\Changes.txt"

# Sleep to allow config to be written to disk
Start-Sleep -Seconds 300

# Extract Revised Durable Config
Add-Content -Path $Results -Value AFTER:
$ActiveConfigData = $ActiveConfig
$ActiveConfigData.durables | Export-Csv $DurableConfigActive
Import-Csv $DurableConfigActive | Select-Object -Property clientid,name,selector,topic | Select-String -Pattern $Durables | Out-File $Results -Append

# Remove unwanted characters from results.txt
(Get-Content -Path $Results) |
ForEach-Object {$_ -Replace '@',''`
                   -Replace '{',''`
                   -Replace '}',''} |
Set-Content $Results

# Split lines to ensure readable content in Results.txt
$HtmlOut = (get-content -Path "$ConfigDestinationDirectory\$ReleaseId\Results.txt") -Join "<br />"

# Mail Results
Send-MailMessage -From <FromAddress> -To <ToAddress> -Subject <Subject> -BodyAsHtml $HtmlOut -SmtpServer <SmtpServer>