<#
    Script;
        Part 1
            Creates a log file (Optional)
            Restarts IIS 
            Stops Logging
            Sends Email
        Part 2
            Checks Log File for string showing success of restart
            Prints a metric value for Monitoring / Observability software
#>

# Part 1
Start-Transcript -Path "<PathToLogFile>"
iisreset /stop /timeout:100
taskkill /F /FI "SERVICES eq was"
iisreset /start
Stop-Transcript
Send-MailMessage -From <FromAddress> -To <ToAddress> -Subject "IISReset on <HostName>" -Body (Get-Content -Path "<PathToLogFile>" | Out-String) -SmtpServer "<SmtpServer>"

# Part 2
$Value1 = (Get-Content -Path "<PathToLogFile>" | Select-String -Pattern "Internet Services Successfully Restarted" | Measure-Object).Count
Write-Host "<EnterMetricUploadPath>, value=$Value1"