# 🚀 Quick Commit Script for Farm Visit PWA
# This script helps commit the core PWA app changes

Write-Host "🌾 Farm Visit PWA - Quick Commit Helper" -ForegroundColor Cyan
Write-Host ""

# Check if we're in the right directory
if (-not (Test-Path "apps/web/package.json")) {
    Write-Host "❌ Error: Must run from 7_farm_visit root directory" -ForegroundColor Red
    Write-Host "   Current directory: $(Get-Location)" -ForegroundColor Yellow
    exit 1
}

Write-Host "📊 Step 1: Checking git status..." -ForegroundColor Yellow
$status = git status --short
$coreFiles = $status | Where-Object { 
    $_ -match 'apps/web/src/' -or 
    $_ -match 'apps/web/package.json' -or 
    $_ -match 'apps/web/test-server.js' -or
    $_ -match 'apps/web/capacitor.config' -or
    $_ -match 'apps/web/vite.config'
}

if ($coreFiles) {
    Write-Host "  ✅ Found core app files to commit:" -ForegroundColor Green
    $coreFiles | ForEach-Object { Write-Host "    $_" -ForegroundColor Gray }
} else {
    Write-Host "  ⚠️  No core app files found in changes" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "📦 Step 2: Checking for sensitive files..." -ForegroundColor Yellow
$sensitive = $status | Where-Object { 
    $_ -match '\.env' -or 
    $_ -match '\.key' -or 
    $_ -match 'secrets' -or
    $_ -match 'node_modules' -or
    $_ -match 'dist/' -or
    $_ -match 'build/'
}

if ($sensitive) {
    Write-Host "  ⚠️  WARNING: Found potentially sensitive files:" -ForegroundColor Red
    $sensitive | ForEach-Object { Write-Host "    $_" -ForegroundColor Red }
    Write-Host "  ⚠️  Review these before committing!" -ForegroundColor Yellow
} else {
    Write-Host "  ✅ No sensitive files found" -ForegroundColor Green
}

Write-Host ""
Write-Host "💡 Step 3: Suggested commit commands" -ForegroundColor Yellow
Write-Host ""

Write-Host "  Option A: Commit Core App Only (Recommended)" -ForegroundColor Cyan
Write-Host "    git add apps/web/src/" -ForegroundColor Gray
Write-Host "    git add apps/web/package.json" -ForegroundColor Gray
Write-Host "    git add apps/web/test-server.js" -ForegroundColor Gray
Write-Host "    git add apps/web/*.ps1 apps/web/*.bat" -ForegroundColor Gray
Write-Host "    git commit -m 'feat: enhance LLM provider and improve PWA functionality'" -ForegroundColor Gray
Write-Host "    git push origin main" -ForegroundColor Gray
Write-Host ""

Write-Host "  Option B: Commit Everything" -ForegroundColor Cyan
Write-Host "    git add ." -ForegroundColor Gray
Write-Host "    git commit -m 'feat: major PWA updates - LLM provider and UI improvements'" -ForegroundColor Gray
Write-Host "    git push origin main" -ForegroundColor Gray
Write-Host ""

Write-Host "  Option C: Interactive (You choose files)" -ForegroundColor Cyan
Write-Host "    git add -p  # Stage changes interactively" -ForegroundColor Gray
Write-Host "    git commit -m 'Your message here'" -ForegroundColor Gray
Write-Host ""

# Ask user what they want to do
Write-Host "❓ What would you like to do?" -ForegroundColor Yellow
Write-Host "   [1] Commit core app files only (Option A)" -ForegroundColor White
Write-Host "   [2] Commit everything (Option B)" -ForegroundColor White
Write-Host "   [3] Show status and exit (manual commit)" -ForegroundColor White
Write-Host "   [4] Cancel" -ForegroundColor White
Write-Host ""
$choice = Read-Host "Enter choice (1-4)"

switch ($choice) {
    "1" {
        Write-Host ""
        Write-Host "📦 Staging core app files..." -ForegroundColor Yellow
        git add apps/web/src/
        git add apps/web/package.json
        git add apps/web/test-server.js
        git add apps/web/*.ps1 -ErrorAction SilentlyContinue
        git add apps/web/*.bat -ErrorAction SilentlyContinue
        
        Write-Host "✅ Files staged. Ready to commit." -ForegroundColor Green
        Write-Host ""
        Write-Host "💬 Enter commit message (or press Enter for default):" -ForegroundColor Yellow
        $message = Read-Host
        if ([string]::IsNullOrWhiteSpace($message)) {
            $message = "feat: enhance LLM provider and improve PWA functionality"
        }
        
        Write-Host ""
        Write-Host "📝 Committing with message: $message" -ForegroundColor Yellow
        git commit -m $message
        
        Write-Host ""
        Write-Host "❓ Push to GitHub now? (y/n)" -ForegroundColor Yellow
        $push = Read-Host
        if ($push -eq "y" -or $push -eq "Y") {
            git push origin main
            Write-Host "✅ Pushed to GitHub!" -ForegroundColor Green
        } else {
            Write-Host "💡 Run 'git push origin main' when ready" -ForegroundColor Cyan
        }
    }
    "2" {
        Write-Host ""
        Write-Host "⚠️  WARNING: This will commit ALL changes including documentation" -ForegroundColor Yellow
        Write-Host "❓ Continue? (y/n)" -ForegroundColor Yellow
        $confirm = Read-Host
        if ($confirm -eq "y" -or $confirm -eq "Y") {
            git add .
            Write-Host "💬 Enter commit message:" -ForegroundColor Yellow
            $message = Read-Host
            git commit -m $message
            
            Write-Host ""
            Write-Host "❓ Push to GitHub now? (y/n)" -ForegroundColor Yellow
            $push = Read-Host
            if ($push -eq "y" -or $push -eq "Y") {
                git push origin main
                Write-Host "✅ Pushed to GitHub!" -ForegroundColor Green
            }
        }
    }
    "3" {
        Write-Host ""
        Write-Host "📊 Full git status:" -ForegroundColor Yellow
        git status
    }
    "4" {
        Write-Host "Cancelled." -ForegroundColor Gray
        exit 0
    }
    default {
        Write-Host "Invalid choice. Exiting." -ForegroundColor Red
        exit 1
    }
}

Write-Host ""
Write-Host "✅ Done!" -ForegroundColor Green



