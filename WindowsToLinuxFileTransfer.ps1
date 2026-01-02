<#
    Script;
        Transfers files from Windows to Linux
#>

echo y | pscp -i "<location of ppk file>" -pw "<password>" -hostkey "<Linux hostkey>" "<Transfer from>" <Linux User>@<Upload to Host>:/<Upload Directory>/