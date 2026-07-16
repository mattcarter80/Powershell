invoke-command -computername "<HostName>" -credential (get-credential DOMAIN\USER) -scriptblock {

# Get Folder Size
$fso = new-object -com Scripting.FileSystemObject
get-childitem -Directory C:\ `
  | select @{l='Size'; e={$fso.GetFolder($_.FullName).Size}},FullName `
  | sort Size -Descending `
  | ft @{l='Size [GB]'; e={'{0:N2}    ' -f ($_.Size / 1GB)}},FullName

#Get freespace on all drives
Get-CimInstance -ClassName Win32_LogicalDisk | Select-Object -Property DeviceID,@{'Name' = 'FreeSpace (GB)'; Expression= { [int]($_.FreeSpace / 1GB) }}