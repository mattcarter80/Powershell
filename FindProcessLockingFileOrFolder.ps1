<#
    Script;
        Identifies process locking objects
#>

$File = '<PathToLockedFileOrFolder>'
Get-WmiObject Win32_Process | Where {$_.commandLine -like "*$File*"} | Select name