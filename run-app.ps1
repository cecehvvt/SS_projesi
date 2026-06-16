$ErrorActionPreference = "Stop"

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$mobileDir = Join-Path $root "mobile"
$backendDir = Join-Path $root "backend"
$flutter = "C:\flutter_sdk\flutter\bin\flutter.bat"
$javaHome = "C:\Program Files\Android\Android Studio\jbr"
$backendUrl = "http://127.0.0.1:8081"

if (-not (Test-Path $flutter)) {
    $flutter = "flutter"
}

function Stop-Port8081 {
    $existingPids = Get-NetTCPConnection -LocalPort 8081 -ErrorAction SilentlyContinue |
        Select-Object -ExpandProperty OwningProcess -Unique

    foreach ($processId in $existingPids) {
        if ($processId) {
            Write-Host "8081 portundaki eski surec kapatiliyor: $processId"
            Stop-Process -Id $processId -Force -ErrorAction SilentlyContinue
        }
    }
}

function Wait-HttpReady {
    param([string] $Url)

    for ($i = 0; $i -lt 60; $i++) {
        try {
            $response = Invoke-WebRequest -UseBasicParsing -Uri $Url -TimeoutSec 2
            if ($response.StatusCode -ge 200 -and $response.StatusCode -lt 500) {
                return $true
            }
        } catch {
            Start-Sleep -Seconds 1
        }
    }

    return $false
}

function Get-LocalIp {
    $ip = Get-NetIPAddress -AddressFamily IPv4 |
        Where-Object {
            $_.IPAddress -notlike "127.*" -and
            $_.IPAddress -notlike "169.254.*" -and
            $_.PrefixOrigin -ne "WellKnown"
        } |
        Select-Object -First 1 -ExpandProperty IPAddress

    if (-not $ip) {
        return "127.0.0.1"
    }

    return $ip
}

function Start-Backend {
    Stop-Port8081

    $out = Join-Path $backendDir "backend.out.log"
    $err = Join-Path $backendDir "backend.err.log"
    $mvnw = Join-Path $backendDir "mvnw.cmd"
    $env:JAVA_HOME = $javaHome

    if (-not (Test-Path $mvnw)) {
        throw "Backend Maven dosyasi bulunamadi: $mvnw"
    }

    Write-Host "Backend arka planda baslatiliyor..."
    Start-Process `
        -FilePath $mvnw `
        -ArgumentList @("spring-boot:run") `
        -WorkingDirectory $backendDir `
        -RedirectStandardOutput $out `
        -RedirectStandardError $err `
        -WindowStyle Hidden `
        -PassThru | Out-Null

    if (-not (Wait-HttpReady $backendUrl)) {
        Write-Host "Backend beklenen surede hazir olmadi. Loglar:"
        Write-Host $out
        Write-Host $err
        throw "Backend baslatilamadi."
    }

    Write-Host "Backend hazir: $backendUrl"
}

function Stop-GradleDaemons {
    $gradlew = Join-Path $mobileDir "android\gradlew.bat"
    if (Test-Path $gradlew) {
        Push-Location (Join-Path $mobileDir "android")
        try {
            & $gradlew --stop | Out-Null
        } catch {
            Write-Host "Gradle daemon durdurma atlandi."
        } finally {
            Pop-Location
        }
    }
}

function Clear-ToolLocks {
    Remove-Item -LiteralPath "C:\flutter_sdk\flutter\bin\cache\lockfile" -Force -ErrorAction SilentlyContinue
    Get-ChildItem -Path (Join-Path $env:USERPROFILE ".gradle\wrapper\dists") `
        -Recurse `
        -Include "*.lck", "*.lock" `
        -ErrorAction SilentlyContinue |
        Remove-Item -Force -ErrorAction SilentlyContinue
}

$localIp = Get-LocalIp
$apiBaseUrl = "http://${localIp}:8081/api"

Start-Backend

Write-Host ""
Write-Host "Flutter cihaz akisi basliyor..."
Write-Host "Labelscan'deki gibi cihaz secimi Flutter tarafindan yapilacak."
Write-Host "Mobil API adresi: $apiBaseUrl"
Write-Host ""

Push-Location $mobileDir
try {
    Clear-ToolLocks
    & $flutter pub get
    & $flutter config --enable-web
    Stop-GradleDaemons
    Write-Host ""
    Write-Host "Flutter'in gordugu cihazlar:"
    & $flutter devices
    Write-Host ""
    & $flutter run --dart-define=API_BASE_URL=$apiBaseUrl
} finally {
    Pop-Location
}
