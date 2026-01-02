<#
    Script;
        Allows you to specify the version of an application to copy and extract from Network Share to other location
#>

Write-Host "Enter Release Number"
$Release = Read-Host -Prompt 'Release.....'

Copy-Item -Path "<\\Network>\File\Share>\$Release.zip" -Destination "<\\Copy\To\Path>\$Release.zip"
Expand-Archive -Path "<\\Copy\To\Path>\$Release.zip" -DestinationPath "<\\Copy\To\Path>\$Release"
Remove-Item -Path "<\\Copy\To\Path>\$Release.zip>"
Copy-Item -Path "<\\Copy\To\Path>\$Release" -Destination "<\\Final\Network\Destination>\$Release" -Recurse -Container