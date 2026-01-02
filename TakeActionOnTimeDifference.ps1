<#
    Script;
        Compares latest known 'good' string in application log to system time.
        If time difference between log and system exceeds 'x' mins, restart service
#>

$LogDate = Get-Date -format "yyyy-MM-dd"
$TimeStamp = Get-Date -format "HHmmss"
$SearchString = (Get-Content -Path "<PathToLogFile>" | Select-String -Pattern "<KnownGoodString>" | Select-Object -Last 1 | Out-string)
$LastSuccess = $SearchString.Substring(StartingCharacter,CountToEndCharacter)
$LogDateTime = [DateTime]::parseexact($LastSuccess, 'HH:mm:ss', $null)
$SystemDate = (Get-Date).ToUniversalTime()
$TimeDifference = $LogDate - $SystemDate

$TimeDifference.minutes # Run query to here to find time difference and use result to provide realistic $TimeDifference.Minutes below

<#
Run this to restart service;

if ($TimeDifference.Minutes -ne 0) {
    Stop-Process -Name "<ProcessName>" -Force -ErrorAction SilentlyContinue
    Start-Sleep -Seconds 10
    Rename-Item -Path "<PathToLogFile>" -NewName "<PathToLogFile>-$LogDate-$TimeStamp"
    Start-Service -Name "<ServiceName>
    Send-MailMessage -From <FromAddress> -To <ToAddress> -Subject "<Subject>" -Body (Get-Content -Path "<PathtoLogFile>") -SmtpServer <SmtpServer>
    }
#>