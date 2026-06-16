$ErrorActionPreference = "Stop"

$adb = Join-Path $env:LOCALAPPDATA "Android\Sdk\platform-tools\adb.exe"

if (-not (Test-Path $adb)) {
    $adb = "adb"
}

Write-Host "Android cihazlar:"
& $adb devices -l

Write-Host "Redmi/Android icin backend portu telefona yonlendiriliyor..."
& $adb reverse tcp:8081 tcp:8081

$gradleConfigCache = Join-Path $PSScriptRoot "android\.gradle\configuration-cache"
if (Test-Path $gradleConfigCache) {
    Write-Host "Eski Gradle configuration-cache temizleniyor..."
    Remove-Item -LiteralPath $gradleConfigCache -Recurse -Force -ErrorAction SilentlyContinue
}

Write-Host "Hazir. Bu klasorde artik normal komutu kullanabilirsin:"
Write-Host "flutter run"
