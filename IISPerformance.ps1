<#
    Script;
        Shows:
            Connections to Websites
            Running Processes, sorted by Paged Memory
            Queue Requests
            CPU, DISK IO and Memory Stats
            Disk IO by Process
            All above stats written to file
#>

#Website Connections
Import-Module WebAdministration
$SiteName = dir IIS:\Sites | Select Names
function Get-CurrentConnection($Site) {
    Get-Counter "web service($Site)\current connections" -ComputerName $env:COMPUTERNAME
} 
$CurrentConnection = @()
    foreach ($Site in $SiteName) {
        Write-Host $Site
        $CC = New-Object psobject | Get-CurrentConnection -Site $Site.Names
        $CurrentConnection += $CC
    }
$CurrentConnection | Out-File "<PathToOutputFile>.txt"

# Top 10 Processes sorted by Paged Memory
Get-Process | Sort-Object PagedMemorySize64 -Descending | Select-Object -First 10 | Out-File "<PathToOutputFile>.txt" -Append

# IIS Queue Requests
Get-Counter -Counter "\HTTP Service Request Queues(<websitename>)\*" | Out-File "<PathToOutputFile>.txt" -Append

# CPU, Disk IO (total), Disk IO (process), Memory (committed) and Memory (cache faults) 
Get-Counter -Counter "\processor(_total)\% processor time" | Out-File "<PathToOutputFile>.txt" -Append
Get-Counter -Counter "\process(_total)\IO Data Operations/sec" | Out-File "<PathToOutputFile>.txt" -Append
Get-Counter -Counter "\process(*)\IO Data Operations/sec" | Out-File "<PathToOutputFile>.txt" -Append
Get-Counter -Counter "\memory\% committed bytes in use" | Out-File "<PathToOutputFile>.txt" -Append
Get-Counter -Counter "\memory\cache faults/sec" | Out-File "<PathToOutputFile>.txt" -Append