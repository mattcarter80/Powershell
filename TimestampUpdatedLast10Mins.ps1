<#
    Script;
        ** Pre-Requisite: Install SQL Server Powershell Module from https://www.powershellgallery.com/packages/sqlserver/22.2.0 to location found at $env:PSModulePath **
        Checks DB and ensures that table has been updated in last 'x' minutes. Column Names to be defined in ColumnX and ColumnY
        Prints a metric value for Monitoring / Observability software
#>

$TimeStamp = Invoke-SQLCmd -ServerInstance "<Host,Port>" -Username "<User>" -Password "<Password>" -Query "USE DB1;
                SELECT TOP (1)
                    ColumnX,
                    ColumnY,
                    CASE
                        WHEN ColumnY >= DATEADD(MINUTE, -10, SYSUTCDATETIME())
                            THEN 1
                        ELSE 0
                    END AS MetricValue
                FROM [DB1].[dbo].[Table1]
                ORDER BY ColumnY DESC;"
$Value1 = if ($TimeStamp.MetricValue -eq "1") {Write-Output '1'} else {Write-Output '0'}
Write-Host "<EnterMetricUploadPath>, value=$Value1"