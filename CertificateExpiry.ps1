<#
    Script;
        Checks Certificate Store for any SSL certs expring in < 60 days
        Prints a metric value for Monitoring / Observability software
#>

$Value = (Get-ChildItem -Path Cert:\LocalMachine\My -ExpiringInDays 59).count
Write-Host "<EnterMetricUploadPath>, value=$Value"