<#
PowerShell recovery script - run from repo root.
Close Visual Studio before running.
#>
Set-StrictMode -Version Latest

Write-Host "Starting recovery script..." -ForegroundColor Cyan

# Ensure git is available
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
  Write-Error "git is not available in PATH. Install Git and re-run."
  exit 1
}

# Ask user to confirm they've closed Visual Studio
$ok = Read-Host "Have you closed Visual Studio and any editors that may lock files? (y/n)"
if ($ok -ne 'y' -and $ok -ne 'Y') {
  Write-Host "Please close Visual Studio and re-run the script." -ForegroundColor Yellow
  exit 1
}

# Fetch and reset main to remote
Write-Host "Fetching origin..."
git fetch origin

Write-Host "Checking out main..."
try {
  git checkout main
} catch {
  Write-Warning "Checkout failed; attempting to remove .vs and retry."
  if (Test-Path .vs) {
    Write-Host "Removing .vs folder to release locks..." -ForegroundColor Yellow
    try { Remove-Item -Recurse -Force .vs } catch { Write-Warning "Failed to remove .vs: $_" }
  }
  git checkout main
}

Write-Host "Resetting main to origin/main (hard)..."
git reset --hard origin/main

# Untrack .vs if it's still tracked
if (git ls-files --error-unmatch ".vs" 2>$null) {
  Write-Host "Removing tracked .vs from git index..."
  git rm -r --cached .vs || Write-Warning "git rm --cached .vs failed"
  git add .gitignore
  git commit -m "chore: stop tracking .vs and ignore editor files" || Write-Host "No changes to commit"
  git push origin main
} else {
  Write-Host ".vs not tracked or already removed." -ForegroundColor Green
}

Write-Host "Ensure 'public' contains your site. If your site files are at repo root, move them into public now." -ForegroundColor Yellow
Write-Host "Example (PowerShell):`n  mkdir public; Move-Item index.html public/; Move-Item assets public/ -Force`" -ForegroundColor Yellow

Write-Host "When ready, run: git add public; git commit -m 'chore: add public site assets'; git push origin main" -ForegroundColor Cyan

Write-Host "Done." -ForegroundColor Green
