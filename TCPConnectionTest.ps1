<#
    Script;
        Runs Test-NetConnection to Host / Port
        Prints a metric value for Monitoring / Observability software
#>

$TelnetTest = Test-NetConnection <HostName> -p <Port> | Select -ExpandProperty TcpTestSucceeded
$TelnetTestResult = $TelnetTest
$Value1 = if ($TelnetTestResult = 'True') {Write-Output '1'} else {Write-Output 'False'}
Write-Host "<EnterMetricUploadPath>, value=$Value1"