# IIS Configuration Script
# Amends Application Pool and Site settings

Import-Module WebAdministration

# ===== VARIABLES - CHANGE THESE =====
$AppPoolName = "YourAppPoolName"
$SiteName = "YourSiteName"
$IdentityUsername = "DOMAIN\ServiceAccount"
$IdentityPassword = "YourPassword"
$LogDirectory = "D:\Weblogs\YourSite"

# ===== APPLICATION POOL SETTINGS =====

# Set Identity to specific user
Set-ItemProperty -Path "IIS:\AppPools\$AppPoolName" -Name processModel.identityType -Value 3  # 3 = SpecificUser
Set-ItemProperty -Path "IIS:\AppPools\$AppPoolName" -Name processModel.userName -Value $IdentityUsername
Set-ItemProperty -Path "IIS:\AppPools\$AppPoolName" -Name processModel.password -Value $IdentityPassword

# Set Idle Time-out to zero (disabled)
Set-ItemProperty -Path "IIS:\AppPools\$AppPoolName" -Name processModel.idleTimeout -Value "00:00:00"

# Set Regular Time Interval (recycling) to zero (disabled)
Set-ItemProperty -Path "IIS:\AppPools\$AppPoolName" -Name recycling.periodicRestart.time -Value "00:00:00"

Write-Host "Application Pool '$AppPoolName' configured successfully."

# ===== SITE SETTINGS =====

# Add Hidden Segment to Request Filtering (settings.json)
$filterPath = "system.webServer/security/requestFiltering"
Add-WebConfigurationProperty -PSPath "IIS:\Sites\$SiteName" -Filter "$filterPath/hiddenSegments" -Name "." -Value @{segment="filename.type"}

Write-Host "Hidden segment 'settings.json' added to Request Filtering."

# Set Logging directory and enable both Log File and ETW events
Set-ItemProperty -Path "IIS:\Sites\$SiteName" -Name logFile.directory -Value $LogDirectory
Set-ItemProperty -Path "IIS:\Sites\$SiteName" -Name logFile.logTargetW3C -Value 3  # 1=File, 2=ETW, 3=Both

Write-Host "Logging configured: directory='$LogDirectory', target=File+ETW"

Write-Host "`nAll settings applied successfully."
