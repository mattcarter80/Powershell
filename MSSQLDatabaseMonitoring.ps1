<#
    Script;
        ** Pre-Requisite: Install SQL Server Powershell Module from https://www.powershellgallery.com/packages/sqlserver/22.2.0 to location found at $env:PSModulePath **
        Checks for the below items:
        Replication Status - Runs on Distribution Database that sits between Source and Target
            1   Started         GOOD
            2   Succeeded       BAD
            3   In Progress     GOOD
            4   Idle            GOOD
            5   Retrying        BAD
            6   FAILED          BAD
        Replication Warnings - Runs on Distribution Database that sits between Source and Target
        Replication Latency - Runs on Distribution Database that sits between Source and Target
        Index Count
        Triggers Present (to be specified explicitly) 
        File Replication by Timestamp
        File Replication by Record Count
        Prints a metric value for Monitoring / Observability software for each monitored item
#>

# Replication Status
$DBReplicationStatus = Invoke-SQLCmd -ServerInstance "<Host,Port>" -Username "<User>" -Password "<Password>" -Query "Use DISTRIBUTION SELECT Status,Agent_Name FROM dbo.msreplication_monitordata where agent_name like '%<agent_name>%'" | Select -ExpandProperty Status
$DBReplicationStatusResult = $DBReplicationStatus
$Value1 = if ($DBReplicationStatusResult -eq '4' -or '3' -or '1') {Write-Output '1'} else {Write-Output '0'}
Write-Host "<EnterMetricUploadPath>, value=$Value1"

# Replication Warnings
$DBReplicationWarning = Invoke-SQLCmd -ServerInstance "<Host,Port>" -Username "<User>" -Password "<Password>" -Query "Use DISTRIBUTION SELECT warning as Warning FROM dbo.msreplication_monitordata where agent_name like '%<agent_name>%'" | Select -ExpandProperty Warning
$DBReplicationWarningResult = $DBReplicationWarning
$Value2 = if ($DBReplicationWarningResult -eq '4' -or '3' -or '1') {Write-Output '1'} else {Write-Output '0'}
Write-Host "<EnterMetricUploadPath>, value=$Value2"

# Replication Latency
$DBReplicationLatency = Invoke-SQLCmd -ServerInstance "<Host,Port>" -Username "<User>" -Password "<Password>" -Query "Use DISTRIBUTION SELECT cur_latency as Latency FROM dbo.msreplication_monitordata where agent_name like '%<agent_name>%'" | Select -ExpandProperty Latency
$DBReplicationLatencyResult = $DBReplicationLatency
$Value3 = if ($DBReplicationLatencyResult -eq '4' -or '3' -or '1') {Write-Output '1'} else {Write-Output '0'}
Write-Host "<EnterMetricUploadPath>, value=$Value3"

# Index Count - RUn SQL first to obtain count, then enter result at '<IndexCount>'
$DBIndexCount = Invoke-SQLCmd -ServerInstance "<Host,Port>" -Username "<User>" -Password "<Password>" -Query "Use <DBName> SELECT count (*) FROM sys.indexes WITH (NOLOCK)" | Select -ExpandProperty Column1
$DBIndexCountResult = $DBIndexCount
$Value4 = if ($DBIndexCountResult -eq '<IndexCount>') {Write-Output '1'} else {Write-Output '0'}
Write-Host "<EnterMetricUploadPath>, value=$Value4"

# Triggers Present - Run SQL first to obtain Trigger Name(s), then enter result at '<TriggerName>'
$DBTrigger = Invoke-SQLCmd -ServerInstance "<Host,Port>" -Username "<User>" -Password "<Password>" -Query "Use <DBName> SELECT * FROM sys.triggers WITH (NOLOCK)" | Select -ExpandProperty Name
$Value5 = if ($DBTrigger -contains '<TriggerName>') {Write-Output '1'} else {Write-Output '0'}
Write-Host "<EnterMetricUploadPath>, value=$Value5"

# File Replication by TImeStamp - Run SQL first to obtain 'Modified' Date / Time
$Table1 = Invoke-SQLCmd -ServerInstance "<Host,Port>" -Username "<User>" -Password "<Password>" -Query "SELECT TOP (1) * FROM [DB1].[dbo].[Table1] WITH (NOLOCK) order by <Modified Date Time> desc" | Select Expand-Property <Modified Date Time>
$Table1Result = $Table1
$Table2 = Invoke-SQLCmd -ServerInstance "<Host,Port>" -Username "<User>" -Password "<Password>" -Query "SELECT TOP (1) * FROM [DB2].[dbo].[Table2] WITH (NOLOCK) order by <Modified Date Time> desc" | Select Expand-Property <Modified Date Time>
$Table2Result = $Table2
$Value6 = if ($Table1Result -eq $Table2Result) {Write-Output '1'} else {Write-Output '0'}
Write-Host "<EnterMetricUploadPath>, value=$Value6"

# File Replication by Record Count
$Table3 = Invoke-SQLCmd -ServerInstance "<Host,Port>" -Username "<User>" -Password "<Password>" -Query "SELECT COUNT (*) FROM [DB1].[dbo].[Table1] WITH (NOLOCK)" | Select Expand-Property Column1
$Table3Result = $Table3
$Table4 = Invoke-SQLCmd -ServerInstance "<Host,Port>" -Username "<User>" -Password "<Password>" -Query "SELECT COUNT (*) FROM [DB2].[dbo].[Table2] WITH (NOLOCK)" | Select Expand-Property Column1
$Table4Result = $Table4
$Value7 = if ($Table3Result -eq $Table4Result) {Write-Output '1'} else {Write-Output '0'}
Write-Host "<EnterMetricUploadPath>, value=$Value7"