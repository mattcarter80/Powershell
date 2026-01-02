<#
    Script;
        Checks Service is Running
        Prints a metric value for Monitoring / Observability software
#>

$ServiceName = Get-Service -Name "<ServiceName>"
$Value1 = if ($ServiceName.Status -eq 'Running') {Write-Output '1'} else {Write-Output '0'}
Write-Host "<EnterMetricUploadPath>, value=$Value1"