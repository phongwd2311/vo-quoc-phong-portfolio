param(
  [int]$Port = 3000
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

Write-Host "Serving portfolio from: $projectRoot"

if (Get-Command py -ErrorAction SilentlyContinue) {
  Write-Host "Open http://localhost:$Port"
  py -m http.server $Port
  exit $LASTEXITCODE
}

if (Get-Command python -ErrorAction SilentlyContinue) {
  Write-Host "Open http://localhost:$Port"
  python -m http.server $Port
  exit $LASTEXITCODE
}

if (Get-Command npx -ErrorAction SilentlyContinue) {
  Write-Host "Python was not found. Falling back to npx serve."
  npx --yes serve . -l $Port
  exit $LASTEXITCODE
}

throw "No local static server is available. Install Python or use Node.js/npx."
