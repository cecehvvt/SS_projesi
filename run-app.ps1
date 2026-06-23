$ErrorActionPreference = "Stop"
$FlutterRunArguments = @($args)

$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$mobileDir = Join-Path $root "mobile"
$backendDir = Join-Path $root "backend"
$flutter = "C:\flutter_sdk\flutter\bin\flutter.bat"
$javaHome = "C:\Program Files\Android\Android Studio\jbr"
$backendUrl = "http://127.0.0.1:8081"

if (-not (Test-Path $flutter)) {
    $flutter = "flutter"
}

function Clear-StaleFlutterRun {
    $staleProcesses = Get-Process dart, dartvm -ErrorAction SilentlyContinue
    if ($staleProcesses) {
        Write-Host "Önceki Flutter oturumu kapatılıyor..."
        $staleProcesses | Stop-Process -Force -ErrorAction SilentlyContinue
        Start-Sleep -Milliseconds 500
    }

    $flutterAssets = Join-Path $mobileDir "build\flutter_assets"
    if (Test-Path -LiteralPath $flutterAssets) {
        Remove-Item -LiteralPath $flutterAssets -Recurse -Force -ErrorAction SilentlyContinue
    }

    $flutterBuildCache = Join-Path $mobileDir ".dart_tool\flutter_build"
    if (Test-Path -LiteralPath $flutterBuildCache) {
        Remove-Item -LiteralPath $flutterBuildCache -Recurse -Force -ErrorAction SilentlyContinue
    }
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

function Test-BackendReady {
    try {
        $response = Invoke-WebRequest -UseBasicParsing -Uri $backendUrl -TimeoutSec 2
        return $response.StatusCode -ge 200 -and $response.StatusCode -lt 500
    } catch {
        return $false
    }
}

function Start-Backend {
    $out = Join-Path $backendDir "backend.out.log"
    $err = Join-Path $backendDir "backend.err.log"
    $mvnw = Join-Path $backendDir "mvnw.cmd"
    $env:JAVA_HOME = $javaHome

    if (-not (Test-Path $mvnw)) {
        throw "Backend Maven dosyasi bulunamadi: $mvnw"
    }

    $envFile = Join-Path $backendDir ".env"
    if (-not (Test-Path $envFile)) {
        throw "Supabase ayari eksik. backend\.env.example dosyasini backend\.env olarak kopyalayip SUPABASE_DB_PASSWORD degerini girin."
    }

    $passwordLine = Get-Content -LiteralPath $envFile |
        Where-Object { $_ -match '^\s*SUPABASE_DB_PASSWORD\s*=\s*(.+)\s*$' } |
        Select-Object -First 1
    if (-not $passwordLine -or $passwordLine -match 'your_supabase_database_password') {
        throw "backend\.env icindeki SUPABASE_DB_PASSWORD gercek Supabase veritabani sifresi olmali."
    }

    if (Test-BackendReady) {
        Write-Host "Backend zaten hazir: $backendUrl"
        return
    }

    Stop-Port8081

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

function Enable-AndroidPortReverse {
    $adb = Join-Path $env:LOCALAPPDATA "Android\Sdk\platform-tools\adb.exe"
    if (-not (Test-Path $adb)) {
        return
    }

    $previousErrorAction = $ErrorActionPreference
    $ErrorActionPreference = "Continue"
    try {
        $androidDevices = & $adb devices 2>$null |
            Where-Object { $_ -match "\sdevice$" }
        if ($androidDevices) {
            & $adb reverse tcp:8081 tcp:8081 2>$null | Out-Null
            if ($LASTEXITCODE -eq 0) {
                Write-Host "Android cihaz icin localhost:8081 yonlendirmesi hazir."
            }
        }
    } finally {
        $ErrorActionPreference = $previousErrorAction
    }
}

$apiBaseUrl = "http://127.0.0.1:8081/api"

Clear-StaleFlutterRun
Start-Backend
Enable-AndroidPortReverse

Push-Location $mobileDir
try {
    if (-not (Test-Path -LiteralPath (Join-Path $mobileDir ".dart_tool\package_config.json"))) {
        & $flutter pub get
        if ($LASTEXITCODE -ne 0) {
            exit $LASTEXITCODE
        }
    }

    $hasApiBaseUrl = $FlutterRunArguments |
        Where-Object { $_ -match '^--dart-define=API_BASE_URL=' }
    if (-not $hasApiBaseUrl) {
        $FlutterRunArguments += "--dart-define=API_BASE_URL=$apiBaseUrl"
    }

    & $flutter run @FlutterRunArguments
    exit $LASTEXITCODE
} finally {
    Pop-Location
}
