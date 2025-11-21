# 🚀 Commit Fixes Script
# Commits the 5 critical fixes for chat interface

Write-Host "🔧 Committing Critical Fixes" -ForegroundColor Cyan
Write-Host ""

# Check if we're in the right directory
if (-not (Test-Path "apps/web/src/lib/llm/LLMProvider.ts")) {
    Write-Host "❌ Error: Must run from 7_farm_visit root directory" -ForegroundColor Red
    exit 1
}

Write-Host "📦 Step 1: Staging critical fixes..." -ForegroundColor Yellow

# Stage the 3 fixed files
git add apps/web/src/lib/llm/LLMProvider.ts
git add apps/web/src/components/ChatDrawer.tsx
git add apps/web/src/lib/api.ts

# Stage .gitattributes if it exists
if (Test-Path ".gitattributes") {
    git add .gitattributes
    Write-Host "  ✅ Added .gitattributes for line ending normalization" -ForegroundColor Green
}

Write-Host "  ✅ Staged LLMProvider.ts (auto mode fix)" -ForegroundColor Green
Write-Host "  ✅ Staged ChatDrawer.tsx (error handling fix)" -ForegroundColor Green
Write-Host "  ✅ Staged api.ts (connection error fix)" -ForegroundColor Green

Write-Host ""
Write-Host "📝 Step 2: Committing..." -ForegroundColor Yellow

$commitMessage = "fix: improve auto mode, error handling, and API connection errors`n`nCritical fixes:`n- Skip Nano check on web in auto mode (prevents unnecessary async calls)`n- Enhanced error messages with actionable steps for users`n- Better API connection error detection and handling`n- Improved user feedback for chat failures (offline, no API key, server down)`n`nFixes #1: Auto mode trying Nano on web`nFixes #2: Poor error handling for chat interface`nFixes #3: API connection errors not caught properly`nFixes #4: Missing server startup instructions"

git commit -m $commitMessage

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✅ Commit successful!" -ForegroundColor Green
    Write-Host ""
    Write-Host "📤 Step 3: Push to GitHub?" -ForegroundColor Yellow
    $push = Read-Host "Push now? (y/n)"
    
    if ($push -eq "y" -or $push -eq "Y") {
        git push origin main
        if ($LASTEXITCODE -eq 0) {
            Write-Host ""
            Write-Host "✅ Successfully pushed to GitHub!" -ForegroundColor Green
            Write-Host "   View at: https://github.com/aciuffolini/Agentic-Farm-Visit" -ForegroundColor Cyan
        } else {
            Write-Host ""
            Write-Host "❌ Push failed. Check your connection and try again." -ForegroundColor Red
            Write-Host "   Run: git push origin main" -ForegroundColor Yellow
        }
    } else {
        Write-Host ""
        Write-Host "💡 To push later, run: git push origin main" -ForegroundColor Cyan
    }
} else {
    Write-Host ""
    Write-Host "❌ Commit failed. Check the error above." -ForegroundColor Red
    Write-Host ""
    Write-Host "Common issues:" -ForegroundColor Yellow
    Write-Host "  - No changes to commit (files already committed?)" -ForegroundColor Gray
    Write-Host "  - Git user not configured (run: git config user.name 'Your Name')" -ForegroundColor Gray
    Write-Host "  - Large files (check .gitignore)" -ForegroundColor Gray
}

Write-Host ""

