<#
    Script;
        Counts number of open connections on specific local port
#>

$ConnectionCount = Get-NetTCPConnection -LocalPort <Port> -State "Established"
$ConnectionCount.Count
pause