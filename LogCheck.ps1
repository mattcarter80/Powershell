<#
    Script;
        Checks Application Log for:
        Size in MB (abnormal growth)
        Presence (created today)
        Updated in 'x' minutes
        Specific Error String
        Prints a metric value for Monitoring / Observability software for each of the above criteria
#>

# Calculate Size
$FileSize = (Get-Item -Path "<PathToFile>")
$Value1 = [math]::round($FileSize.Length/1MB)
Write-Host "<EnterMetricUploadPath>, value=$Value1"

# Log Present
$Value2 = (Get-ChildItem -Path "<PathToFile>" | Where-Object {$_.LastWriteTime -gt [datetime]::today} | Measure-Object).Count
Write-Host "<EnterMetricUploadPath>, value=$Value2"

# Log being Updated
$Value3 = (Get-ChildItem -Path "<PathToFile>" | Where-Object {$_.LastWriteTime -gt (Get-Date).AddMinutes(-30)} | Measure-Object).Count
Write-Host "<EnterMetricUploadPath>, value=$Value3"

# Specific Error String
$Value4 = (Get-ChildItem -Path "<PathToFile>" | Select-String -Pattern "<ErrorString>" | Measure-Object).Count
Write-Host "<EnterMetricUploadPath>, value=$Value4"