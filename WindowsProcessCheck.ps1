<#
    Script;
        Checks Process is running
        Prints a metric value for Monitoring / Observability software
#>

$Process1 = "<ProcessName>"
$Process1Count = (Get-Process -ProcessName "<ProcessName>").HandleCount
$Value1 = if ($Process1Count -lt 1) {Write-Output '0'} else {Write-Output '1'}
Write-Host "<EnterMetricUploadPath>, value=$Value1"