Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -ErrorAction SilentlyContinue

$TempFiles = @("C:\Windows\Prefetch\*","C:\Windows\Temp\*","C:\Users\mattc\AppData\Local\Google\Chrome\User Data\Default\Cache\Cache_Data\*","C:\Users\mattc\AppData\Local\Microsoft\Edge\User Data\Default\Cache\Cache_Data","C:\Users\mattc\AppData\Local\Temp")

Remove-Item -Path $TempFiles -ErrorAction SilentlyContinue -Recurse -Force

Pause