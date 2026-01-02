<#
    Script;
        Scans Event Viewer Application Log for below Errors that have occurred in last 5 mins:
            1018    W3SVC performance counter initialization failure
            1026    .NET Runtime Error (Application Crash)
            1033    Secure Boot Issue / IIS Logging
        Prints a metric value for Monitoring / Observability software
#>

$EventVwr = Get-WinEvent -FilterHashtable @{LogName='Application';StartTime(Get-Date).AddMinutes(-5)} | Where {$_.Id -in '1033','1026','1018'} | Select -ExpandProperty Id
$EventVwrResult = $EventVwr
$Value1 = if ($EventVwrResult -in '1033','1026','1018') {Write-Output '0'} else {Write-Output '1'}
Write-Host "<EnterMetricUploadPath>, value=$Value1"