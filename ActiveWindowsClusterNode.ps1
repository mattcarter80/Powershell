<#
    Script;
        Shows Owner Node in 3 node Windows Cluster and Cluster Active State
        Prints a metric value for Monitoring / Observability software
#>

# Active Node
$ClusterOwner = Get-ClusterResource -Name "<ClusterName>" | Select -ExpandProperty OwnerNode
$Value1 = if($ClusterOwner.Name -eq "<NODE1>") {Write-Output '1'}
Write-Host "<EnterMetricUploadPath>, value=$Value1"
$Value2 = if($ClusterOwner.Name -eq "<NODE2>") {Write-Output '2'}
Write-Host "<EnterMetricUploadPath>, value=$Value2"
$Value3 = if($ClusterOwner.Name -eq "<NODE3>") {Write-Output '3'}
Write-Host "<EnterMetricUploadPath>, value=$Value3"

# Cluster Active State
$ClusterState = Get-ClusterResource -Name "<ClusterName>" | Select -ExpandProperty State
$Value1 = if ($ClusterState -eq "Offline") {Write-Output '0'} else {Write-Output '1'}
Write-Host "<EnterMetricUploadPath>, value=$Value1"
