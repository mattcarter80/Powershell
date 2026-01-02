<#
    Script;
        Checks Status of Website and returns Status Code (200 = Good)
        Checks Status if IIS Application Pool on Local Machine
        Prints a metric value for Monitoring / Observability software
#>

$WebsiteStatus = Invoke-WebRequest -Uri "https://www.google.com" -UseBasicParsing | % {$_.StatusCode}
Write-Host "<EnterMetricUploadPath>, value=$WebsiteStatus"

$LocalPoolStatus = Import-Module WebAdministration; Get-Item "IIS:\AppPools\<PoolName>" | Select-Object -Expand State 
$LocalPoolStatus = if ("Started") {Write-Output '1'} else {Write-Output '0'}
Write-Host "<EnterMetricUploadPath>, value=$LocalPoolStatus"