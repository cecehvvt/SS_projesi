$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$mobileDir = Join-Path $root "mobile"
$flutter = "C:\flutter_sdk\flutter\bin\flutter.bat"
$adb = Join-Path $env:LOCALAPPDATA "Android\Sdk\platform-tools\adb.exe"

if (-not (Test-Path $flutter)) {
    $flutter = "flutter"
}

if (-not (Test-Path $adb)) {
    $adb = "adb"
}

$ip = Get-NetIPAddress -AddressFamily IPv4 |
    Where-Object {
        $_.IPAddress -notlike "127.*" -and
        $_.IPAddress -notlike "169.254.*" -and
        $_.PrefixOrigin -ne "WellKnown"
    } |
    Select-Object -First 1 -ExpandProperty IPAddress

if (-not $ip) {
    throw "Bilgisayarin yerel IP adresi bulunamadi. Telefon ve bilgisayar ayni Wi-Fi aginda olmali."
}

$apiBaseUrl = "http://${ip}:8081/api"
Write-Host "Telefon API adresi: $apiBaseUrl"
Write-Host "Bagli Android cihazlar kontrol ediliyor..."
& $adb devices

Push-Location $mobileDir
try {
    Write-Host "APK hazirlaniyor..."
    & $flutter pub get
    & $flutter build apk --debug --dart-define=API_BASE_URL=$apiBaseUrl

    $apk = Join-Path $mobileDir "build\app\outputs\flutter-apk\app-debug.apk"
    if (-not (Test-Path $apk)) {
        throw "APK bulunamadi: $apk"
    }

    Write-Host "APK telefona yukleniyor..."
    & $adb install -r $apk
    Write-Host "Tamamlandi. Telefon ana ekraninda uygulama adi: Vesta"
} finally {
    Pop-Location
}
