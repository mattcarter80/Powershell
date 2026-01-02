<#
    Script;
        Collates basic performance counters and writes to file
#>

# CPU, Disk IO (total), Disk IO (process), Memory (committed) and Memory (cache faults) 
Get-Counter -Counter "\processor(_total)\% processor time" | Out-File "<PathToOutputFile>.txt" -Append
Get-Counter -Counter "\process(_total)\IO Data Operations/sec" | Out-File "<PathToOutputFile>.txt" -Append
Get-Counter -Counter "\process(*)\IO Data Operations/sec" | Out-File "<PathToOutputFile>.txt" -Append
Get-Counter -Counter "\memory\% committed bytes in use" | Out-File "<PathToOutputFile>.txt" -Append
Get-Counter -Counter "\memory\cache faults/sec" | Out-File "<PathToOutputFile>.txt" -Append