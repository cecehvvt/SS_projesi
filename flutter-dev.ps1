$FlutterArguments = @($args)
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$flutter = "C:\flutter_sdk\flutter\bin\flutter.bat"
if (-not (Test-Path -LiteralPath $flutter)) {
    $flutter = "flutter"
}

if ($FlutterArguments.Count -gt 0 -and $FlutterArguments[0] -eq "run") {
    $runArguments = @($FlutterArguments | Select-Object -Skip 1)
    & (Join-Path $root "run-app.ps1") @runArguments
    exit $LASTEXITCODE
}

& $flutter @FlutterArguments
exit $LASTEXITCODE
