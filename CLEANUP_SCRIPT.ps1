# 🧹 Cleanup Script - Remove Unnecessary Files
# Run this to clean up temporary/debug files before committing

Write-Host "🧹 Cleaning up unnecessary files..." -ForegroundColor Cyan
Write-Host ""

# Files to delete (temporary/debug)
$filesToDelete = @(
    "*_SUMMARY.md",
    "*_ANALYSIS.md", 
    "COMMIT_*.md",
    "PUSH_*.md",
    "GITHUB_COMMIT_*.md",
    "TEST_CHAT_*.md",
    "TEST_*.md",
    "STATUS*.md",
    "MVP_*.md",
    "COPY_*.md",
    "DEBUG_*.md",
    "FIX_*.md",
    "QUICK_*.md",
    "SIMPLE_TEST.*",
    "SOLUTION_*.md",
    "REVIEW_*.md",
    "WORKFLOW_*.md",
    "DEPLOYMENT_*.md",
    "FAILURE_*.md",
    "ITERATION_*.md",
    "RELEASE_*.md"
)

$deletedCount = 0
$keptCount = 0

foreach ($pattern in $filesToDelete) {
    $files = Get-ChildItem -Filter $pattern -ErrorAction SilentlyContinue
    foreach ($file in $files) {
        # Skip important files
        if ($file.Name -match "README|LICENSE|CHANGELOG|REFACTORING|QUICK_START_SERVER|START_CHAT") {
            Write-Host "  ⏭️  Keeping: $($file.Name)" -ForegroundColor Yellow
            $keptCount++
            continue
        }
        
        Write-Host "  🗑️  Deleting: $($file.Name)" -ForegroundColor Gray
        Remove-Item $file.FullName -Force
        $deletedCount++
    }
}

Write-Host ""
Write-Host "✅ Cleanup complete!" -ForegroundColor Green
Write-Host "   Deleted: $deletedCount files" -ForegroundColor Gray
Write-Host "   Kept: $keptCount important files" -ForegroundColor Gray
Write-Host ""

# Organize documentation
Write-Host "📁 Organizing documentation..." -ForegroundColor Cyan

# Move guides
$guides = @("INSTALL_*.md", "BUILD_*.md", "DEPLOY_*.md", "QUICK_BUILD*.md")
foreach ($pattern in $guides) {
    $files = Get-ChildItem -Filter $pattern -ErrorAction SilentlyContinue
    foreach ($file in $files) {
        if (-not (Test-Path "docs\guides\$($file.Name)")) {
            Move-Item $file.FullName "docs\guides\" -Force -ErrorAction SilentlyContinue
            Write-Host "  📚 Moved: $($file.Name) → docs/guides/" -ForegroundColor Gray
        }
    }
}

# Move architecture docs
$arch = @("FARM_VISIT_ARCHITECTURE.md", "ANDROID_ARCHITECTURE.md", "SECURITY_STRATEGY.md")
foreach ($file in $arch) {
    if (Test-Path $file) {
        if (-not (Test-Path "docs\architecture\$file")) {
            Move-Item $file "docs\architecture\" -Force -ErrorAction SilentlyContinue
            Write-Host "  🏗️  Moved: $file → docs/architecture/" -ForegroundColor Gray
        }
    }
}

Write-Host ""
Write-Host "✅ Organization complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📋 Next steps:" -ForegroundColor Cyan
Write-Host "  1. Review changes: git status" -ForegroundColor White
Write-Host "  2. Test in browser: npm run dev" -ForegroundColor White
Write-Host "  3. Commit when ready: git add . && git commit -m 'refactor: simplify LLM architecture'" -ForegroundColor White



