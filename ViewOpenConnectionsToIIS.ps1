<#
    Script;
        Gets all open conenction to IIS Sites on Local machine
#>

Import-Module WebAdministration
$SiteName = dir IIS:\Sites | Select Names

function Get-CurrentConnection($Site) {
    Get-Counter "web service($Site)\current connections" -ComputerName $env:COMPUTERNAME
} 

$CurrentConnection = @()
    foreach ($Site in $SiteName) {
        Write-Host $Site
        $CC = New-Object psobject | Get-CurrentConnection -Site $Site.Names
        $CurrentConnection += $CC
    }

$CurrentConnection
pause