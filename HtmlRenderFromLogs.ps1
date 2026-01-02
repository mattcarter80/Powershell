<#
Script; 
    1. Streams log files constantly in use to new location
    2. Reads the content of the streamed log
    3. Defines info in hash table to extract from streamed log
    4. Parses info in hash table
    5. Looks for matches in log from hash table
    6. Generates HTML output in table form
    7. Updates HTML output

    This display requires a Scheduled Task to run on an available server
#>

### Define Date 
$Date = Get-Date -format "yyyyMMdd"

### Stream Source Log File to new location
$Source = "<Source Log>"
$Destination = "<Destination Log>"
$Reader = [System.IO.File]::Open($Source, 'Open', 'Read', 'ReadWrite')
$Writer = [System.IO.File]::Create($Destination)
$Buffer = New-Object byte[] 4096
        While (($BytesRead = $Reader.Read($Buffer, 0, $Buffer.Length)) -gt 0) {
            $Writer.Write($Buffer, 0, $BytesRead)
        }
        $Reader.Close()
        $Writer.Close()

### Read the Log File from the Destination
$LogLines = Get-Content $Destination

### Define Hash Tables for Search
$Table1 = @{
    "123456" = "ID1"
    "234567" = "ID2"
    "345678" = "ID3"
    "456789" = "ID4"
}
$Table2 = @{
    "ID5" = "654321"
    "ID6" = "765432"
    "ID7" = "876543"
    "ID8" = "987654"
}

### Parse Log Lines for Table1 Status
$Table1Status = @{}
# Reset status to Unknown 
foreach ($id in $Table1.Keys) {
    $Account = $Table1[$id]
    $Table1Status[$Account] = [PSCustomObject]@{
        Account     = $Account
        ID          = $id
        Status      = "UNKNOWN"
        TimeStamp   = "-"
    }
}
# Parse Log for Latest Entry
foreach ($Line in $LogLines) {
    if ($Line -match "(\d{2}[-/]\d{2}[-/]\d{4} ) \d{2}:\d{2}:\d{2}).*\b(\d{6})\b") {
        $Timestamp  = $Matches[1]
        $id         = $Matches[2]
        $Account    = $Table1[$ID]
        if ($Account) {
            $Status =   if      ($Line -match "LoggedIn") {"Connected"}
                        elseif  ($Line -match "LoggedOut") {"Disconnected"}
                        else    {"UNKNOWN"}
# Update Latest Status and Timestamp
            $Table1Status[$Account] = [PSCustomObject]@{
                Account     =   $Account
                ID          =   $id
                Status      =   $Status
                TimeStamp   =   $TimeStamp
            }
        }
    }
}

### Parse Log Lines for Table2 Status
$Table2Status = @{}
# Reset status to Unknown 
foreach ($id in $Table2.Keys) {
    $Account = $Table2[$id]
    $Table2Status[$Account] = [PSCustomObject]@{
        Account     = $Account
        ID          = $id
        Status      = "UNKNOWN"
        TimeStamp   = "-"
    }
}
# Parse Log for Latest Entry
foreach ($Line in $LogLines) {
    if ($Line -match "(\d{2}[-/]\d{2}[-/]\d{4} ) \d{2}:\d{2}:\d{2}).*\b(\d{6})\b") {
        $Timestamp  = $Matches[1]
        $id         = $Matches[2]
        $Account    = $Table2[$ID]
        if ($Account) {
            $Status =   if      ($Line -match "LoggedIn") {"Connected"}
                        elseif  ($Line -match "LoggedOut") {"Disconnected"}
                        else    {"UNKNOWN"}
# Update Latest Status and Timestamp
            $Table2Status[$Account] = [PSCustomObject]@{
                Account     =   $Account
                ID          =   $id
                Status      =   $Status
                TimeStamp   =   $TimeStamp
            }
        }
    }
}

### Generate HTML Dashboard and refresh every 60 secs
$Html = @"
<html>
<head>
<meta http:equiv='refresh' content='60'
<style>
    body {
        font-family:    'Segoe UI', Tahoma, Geneva, Verdana,sans-serif;
        margin:         10px
        padding:        0;
        }
        .green {background-color: green; color: white; padding: 5px;}
        .red {background-color: red; color: white; padding: 5px;}
        .unknown {background-color: gray; color: white; padding: 5px;}
        .flex-container {
        display: flex;
        justify-content: flex-start;
        align-items: flex-start;
        }
        .table-container {
        flex: 0 0 auto;
        margin-left: 20px; /* Tight Spacing */
        margin-right; 20px; /* Tight Spacing */
        }
        table {
        border-collapse: collapse;
        }
        th, td {
        padding: 4px;
        border: 1px solid #000
        }
</style>
</head>
<body>
<h2> HEADER ON DASHBOARD </h2>
<p><strong>Last Updated at:</strong> $TimeStamp</p>
<div class='flex-container'>
"@
# Table1 Output
$Html += "<div class='table-container'>"
$Html += "<h3>Table1</h3>"
$Html += "<table border='1'><tr><th>Account</th><th>Status</th><th>LastLogEntry</th></tr>"
    foreach ($Item in $Table1Status.Values) {
        $ColorClass = switch ($Item.Status) {
            "Connected"     {"green"}
            "Disconnected"  {"red"}
            default         {"UNKNOWN"}
        }
    $html += "<tr><td>$(Item.Account)</td><td class = '$ColorClass'>$($Item.Status)</td><td>($Item.TimsStamp)</td></tr>"
}
$html += "</table></div>"
# Table2 Output
$Html += "<div class='table-container'>"
$Html += "<h3>Table2</h3>"
$Html += "<table border='1'><tr><th>Account</th><th>Status</th><th>LastLogEntry</th></tr>"
    foreach ($Item in $Table2Status.Values) {
        $ColorClass = switch ($Item.Status) {
            "Connected"     {"green"}
            "Disconnected"  {"red"}
            default         {"UNKNOWN"}
        }
    $html += "<tr><td>$(Item.Account)</td><td class = '$ColorClass'>$($Item.Status)</td><td>($Item.TimsStamp)</td></tr>"
}
$html += "</table></div>"

### Save Results to Dashboard
$DashboardPath = "<Folder Location\Filename.html>"
$Html | Out-file $DashboardPath -Encoding utf8