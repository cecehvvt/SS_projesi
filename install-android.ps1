$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$mobileDir = Join-Path $root "mobile"
$backendDir = Join-Path $root "backend"
$flutter = "C:\flutter_sdk\flutter\bin\flutter.bat"
$adb = Join-Path $env:LOCALAPPDATA "Android\Sdk\platform-tools\adb.exe"
$javaHome = "C:\Program Files\Android\Android Studio\jbr"
$backendUrl = "http://127.0.0.1:8081"

if (-not (Test-Path $flutter)) {
    $flutter = "flutter"
}

if (-not (Test-Path $adb)) {
    $adb = "adb"
}

function Test-BackendReady {
    try {
        $response = Invoke-WebRequest -UseBasicParsing -Uri $backendUrl -TimeoutSec 2
        return $response.StatusCode -ge 200 -and $response.StatusCode -lt 500
    } catch {
        return $false
    }
}

function Start-Backend {
    if (Test-BackendReady) {
        Write-Host "Backend zaten hazir: $backendUrl"
        return
    }

    $envFile = Join-Path $backendDir ".env"
    if (-not (Test-Path $envFile)) {
        throw "backend\.env dosyasi bulunamadi. Supabase ayarini tamamlayin."
    }

    $env:JAVA_HOME = $javaHome
    Start-Process `
        -FilePath (Join-Path $backendDir "mvnw.cmd") `
        -ArgumentList @("spring-boot:run") `
        -WorkingDirectory $backendDir `
        -RedirectStandardOutput (Join-Path $backendDir "backend.out.log") `
        -RedirectStandardError (Join-Path $backendDir "backend.err.log") `
        -WindowStyle Hidden | Out-Null

    Write-Host "Backend baslatiliyor..."
    for ($attempt = 0; $attempt -lt 60; $attempt++) {
        if (Test-BackendReady) {
            Write-Host "Backend hazir: $backendUrl"
            return
        }
        Start-Sleep -Seconds 1
    }

    throw "Backend baslatilamadi. backend\backend.err.log dosyasini kontrol edin."
}

function Get-LanIpAddress {
    $client = [System.Net.Sockets.UdpClient]::new()
    try {
        $client.Connect("8.8.8.8", 65530)
        return ([System.Net.IPEndPoint]$client.Client.LocalEndPoint).Address.ToString()
    } finally {
        $client.Dispose()
    }
}

Start-Backend
$ip = Get-LanIpAddress

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
