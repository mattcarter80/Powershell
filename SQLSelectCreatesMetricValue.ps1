<#
    Script;
        ** Pre-Requisite: Install SQL Server Powershell Module from https://www.powershellgallery.com/packages/sqlserver/22.2.0 to location found at $env:PSModulePath **
        Queries latest record in table
        Ensures that latest timestamp is within 10 mins
        Provides metric value for upload into monitoring / observability solution 
        Alternate query to run if metric returns 0. This checks for any data written to that table today
#>

$LatestTimestamp = Invoke-SQLCmd -ServerInstance "<host,port>" -Username "<user>" -Password "<Password>" -Query "USE DBName;
    SELECT TOP (1)
        Column1,
        Column2,
        CASE
            WHEN <SearchCriteria> >= DATEADD(MINUTE, -10, SYSUTCDATETIME())
                THEN 1
            ELSE 0
        END AS MetricValue
    FROM [DBName].[dbo].[TableName];"
$Value = if ($LatestTimestamp.MetricValue -eq "1") {Write-Output '1'} else {Write-Output '0'}
Write-Host "<EnterMetricUploadPath>, value=$Value"

# Alternate Query
Invoke-SQLCmd -ServerInstance "<host,port>" -Username "<user>" -Password "<Password>" -Query "USE DBName;
SELECT * FROM [DBName].[dbo].[TableName] 
    WHERE <SearchCriteria> >= CAST(GET-DATE() AS DATE) and <SearchCriteria> <DATEADD(DAY, 1, CAST(GETDATE() AS DATE)); 