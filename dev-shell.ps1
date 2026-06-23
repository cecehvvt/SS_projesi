$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$global:VestaFlutterRunner = Join-Path $root "flutter-dev.ps1"

function global:flutter {
    & $global:VestaFlutterRunner @args
}

Set-Location (Join-Path $root "mobile")
Write-Host "Vesta terminali hazir."
Write-Host "Cihazlar: flutter devices"
Write-Host "Chrome:   flutter run -d chrome"
Write-Host "Telefon:  flutter run -d CIHAZ_ID"
Write-Host ""
