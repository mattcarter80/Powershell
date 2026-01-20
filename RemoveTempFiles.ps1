Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process -ErrorAction SilentlyContinue

$TempFiles = @("C:\Windows\Prefetch\*","C:\Windows\Temp\*","C:\Users\<user-profile>\AppData\Local\Google\Chrome\User Data\Default\Cache\Cache_Data\*","C:\Users\<user-profile>\AppData\Local\Microsoft\Edge\User Data\Default\Cache\Cache_Data","C:\Users\<user-profile>\AppData\Local\Temp")

Remove-Item -Path $TempFiles -ErrorAction SilentlyContinue -Recurse -Force


Pause
