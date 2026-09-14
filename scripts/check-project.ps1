$ErrorActionPreference = "Stop"

$projectRoot = Split-Path -Parent $PSScriptRoot
Set-Location $projectRoot

$errors = New-Object System.Collections.Generic.List[string]
$warnings = New-Object System.Collections.Generic.List[string]

$requiredFiles = @("index.html", "styles.css", "script.js")
foreach ($file in $requiredFiles) {
  if (-not (Test-Path -LiteralPath $file -PathType Leaf)) {
    $errors.Add("Missing required file: $file")
  }
}

if (-not (Test-Path -LiteralPath "assets" -PathType Container)) {
  $warnings.Add("Missing assets directory.")
}

if (-not (Test-Path -LiteralPath "AGENTS.md" -PathType Leaf)) {
  $errors.Add("Missing AGENTS.md.")
}

$pdfFiles = @(
  Get-ChildItem -Path "docs/source" -Filter *.pdf -File -ErrorAction SilentlyContinue
  Get-ChildItem -Path "." -Filter *.pdf -File -ErrorAction SilentlyContinue
)

if ($pdfFiles.Count -eq 0) {
  $warnings.Add("No PDF source found under docs/source or repository root.")
}
elseif ($pdfFiles.Count -gt 1) {
  $warnings.Add("Multiple PDF files found. Confirm which file is the canonical CV before content extraction.")
}

$secretPatterns = @(
  'github_pat_[A-Za-z0-9_]+',
  'ghp_[A-Za-z0-9]+',
  'vercel_[A-Za-z0-9_-]+',
  '(?ms)^-----BEGIN PRIVATE KEY-----\r?\n.+?^-----END PRIVATE KEY-----\r?$',
  '(?ms)^-----BEGIN (RSA|EC|OPENSSH) PRIVATE KEY-----\r?\n.+?^-----END \1 PRIVATE KEY-----\r?$'
)

$scanFiles = Get-ChildItem -Recurse -File |
  Where-Object {
    $_.FullName -ne $PSCommandPath -and
    $_.FullName -notmatch '\\.git\\' -and
    $_.Extension -notin @('.pdf', '.png', '.jpg', '.jpeg', '.gif', '.webp', '.ico', '.woff', '.woff2')
  }

foreach ($file in $scanFiles) {
  $content = Get-Content -LiteralPath $file.FullName -Raw -ErrorAction SilentlyContinue
  if ($null -eq $content) { continue }

  foreach ($pattern in $secretPatterns) {
    if ($content -cmatch $pattern) {
      $relative = Resolve-Path -Relative $file.FullName
      $errors.Add("Possible credential found in $relative. Review before committing.")
      break
    }
  }
}

Write-Host ""
Write-Host "Portfolio project check"
Write-Host "======================="

if ($warnings.Count -gt 0) {
  Write-Host ""
  Write-Host "Warnings:"
  foreach ($warning in $warnings) {
    Write-Host "  - $warning"
  }
}

if ($errors.Count -gt 0) {
  Write-Host ""
  Write-Host "Errors:"
  foreach ($checkError in $errors) {
    Write-Host "  - $checkError"
  }
  exit 1
}

Write-Host ""
Write-Host "PASS: required project files are present and no obvious credential pattern was found."
exit 0
