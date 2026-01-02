<#
    Script;
        Cleans up logs older than 'x' days from specified directories
#>

$Path = "PathToLogs"
$DaysBack = "-<DaysToDeleteOlderThan>"
$CurrentDate = Get-Date -format "yyyy-mm-dd"
$DateToDelete = ((Get-Date).AddDays($DaysBack)).ToString("yyyy-MM-dd")

Get-ChildItem $Path -Recurse -Include "*.log" | Where-Object {($_.LastWriteTime -lt $DateToDelete)} | Remove-Item