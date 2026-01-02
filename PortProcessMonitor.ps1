<#
    Script;
        Specifies specifc ports where processes are attached to and monitors teh status of the ports to ensure they are in use
        If a process goes down, the port drops activity 
        Prints a metric value for Monitoring / Observability software
#>

$KnownPortsProcesses = @('1234','5678')
$RemoteAddress = '0.0.0.0'
$PortsResult = Get-NetTCPConnection -LocalPort $KnownPortsProcesses -RemoteAddress $RemoteAddress | Select -ExpandProperty LocalPort
$PortsResultUpload = $PortsResult
$Value1 = if ($PortsResultUpload -Contains '1234') {Write-Output '1'} else {Write-Output '0'}
Write-Host "<EnterMetricUploadPath>, value=$Value1"
$Value2 = if ($PortsResultUpload -Contains '5678') {Write-Output '1'} else {Write-Output '0'}
Write-Host "<EnterMetricUploadPath>, value=$Value2"