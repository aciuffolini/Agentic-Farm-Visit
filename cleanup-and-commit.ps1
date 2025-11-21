# 🧹 Cleanup and Commit Script
# This script helps organize the repository and prepare for commits

Write-Host "🔍 Farm Visit App - Cleanup and Commit Helper" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check git status
Write-Host "📊 Step 1: Checking git status..." -ForegroundColor Yellow
git status --short
Write-Host ""

# Step 2: Create documentation structure
Write-Host "📁 Step 2: Creating documentation structure..." -ForegroundColor Yellow
if (-not (Test-Path "docs")) {
    New-Item -ItemType Directory -Path "docs" | Out-Null
    Write-Host "  ✅ Created docs/ directory" -ForegroundColor Green
}

$docDirs = @("docs/guides", "docs/analysis", "docs/deployment", "docs/troubleshooting", "docs/archive")
foreach ($dir in $docDirs) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
        Write-Host "  ✅ Created $dir/" -ForegroundColor Green
    }
}

# Step 3: Show what would be moved (dry run)
Write-Host ""
Write-Host "📋 Step 3: Files that should be organized:" -ForegroundColor Yellow
Write-Host "  (This is a preview - files are NOT moved automatically)" -ForegroundColor Gray
Write-Host ""

# Guide files
$guideFiles = Get-ChildItem -Filter "INSTALL_*.md", "BUILD_*.md", "QUICK_*.md", "DEPLOY_*.md" -ErrorAction SilentlyContinue
if ($guideFiles) {
    Write-Host "  📚 Guides ($($guideFiles.Count) files):" -ForegroundColor Cyan
    $guideFiles | ForEach-Object { Write-Host "    - $($_.Name)" -ForegroundColor Gray }
}

# Analysis files
$analysisFiles = Get-ChildItem -Filter "*_ANALYSIS.md", "*_SUMMARY.md", "SYSTEMATIC_*.md" -ErrorAction SilentlyContinue
if ($analysisFiles) {
    Write-Host "  📊 Analysis ($($analysisFiles.Count) files):" -ForegroundColor Cyan
    $analysisFiles | ForEach-Object { Write-Host "    - $($_.Name)" -ForegroundColor Gray }
}

# Debug/Test files
$debugFiles = Get-ChildItem -Filter "DEBUG_*.md", "TEST_*.md", "FIX_*.md" -ErrorAction SilentlyContinue
if ($debugFiles) {
    Write-Host "  🐛 Troubleshooting ($($debugFiles.Count) files):" -ForegroundColor Cyan
    $debugFiles | ForEach-Object { Write-Host "    - $($_.Name)" -ForegroundColor Gray }
}

# Commit-related files
$commitFiles = Get-ChildItem -Filter "COMMIT_*.md", "PUSH_*.md", "GITHUB_COMMIT_*.md" -ErrorAction SilentlyContinue
if ($commitFiles) {
    Write-Host "  📝 Commit guides ($($commitFiles.Count) files - should archive):" -ForegroundColor Cyan
    $commitFiles | ForEach-Object { Write-Host "    - $($_.Name)" -ForegroundColor Gray }
}

# Step 4: Show current uncommitted changes
Write-Host ""
Write-Host "📦 Step 4: Current uncommitted changes:" -ForegroundColor Yellow
$status = git status --short
$modified = ($status | Where-Object { $_ -match '^ M' }).Count
$untracked = ($status | Where-Object { $_ -match '^\?\?' }).Count
$deleted = ($status | Where-Object { $_ -match '^ D' }).Count

Write-Host "  Modified: $modified files" -ForegroundColor $(if ($modified -gt 0) { "Yellow" } else { "Green" })
Write-Host "  Untracked: $untracked files" -ForegroundColor $(if ($untracked -gt 0) { "Yellow" } else { "Green" })
Write-Host "  Deleted: $deleted files" -ForegroundColor $(if ($deleted -gt 0) { "Yellow" } else { "Green" })

# Step 5: Suggest commit groups
Write-Host ""
Write-Host "💡 Step 5: Suggested commit groups:" -ForegroundColor Yellow
Write-Host ""

Write-Host "  Group 1: Claude Code Feature" -ForegroundColor Cyan
Write-Host "    git add apps/web/src/lib/llm/LLMProvider.ts" -ForegroundColor Gray
Write-Host "    git add apps/web/src/lib/api.ts" -ForegroundColor Gray
Write-Host "    git add apps/web/src/components/ChatDrawer.tsx" -ForegroundColor Gray
Write-Host "    git add apps/web/test-server.js" -ForegroundColor Gray
Write-Host "    git commit -m 'feat(llm): add Claude Code model support'" -ForegroundColor Gray
Write-Host ""

Write-Host "  Group 2: Documentation (after organizing)" -ForegroundColor Cyan
Write-Host "    git add docs/" -ForegroundColor Gray
Write-Host "    git commit -m 'docs: reorganize documentation structure'" -ForegroundColor Gray
Write-Host ""

Write-Host "  Group 3: Configuration" -ForegroundColor Cyan
Write-Host "    git add apps/web/package.json .gitignore" -ForegroundColor Gray
Write-Host "    git commit -m 'chore(config): update dependencies and gitignore'" -ForegroundColor Gray
Write-Host ""

# Step 6: Check for sensitive files
Write-Host "🔒 Step 6: Checking for sensitive files..." -ForegroundColor Yellow
$sensitiveFiles = @(".env", "*.key", "*.pem", "secrets.json")
$foundSensitive = $false
foreach ($pattern in $sensitiveFiles) {
    $files = Get-ChildItem -Filter $pattern -Recurse -ErrorAction SilentlyContinue | Where-Object { $_.FullName -notmatch "node_modules" }
    if ($files) {
        Write-Host "  ⚠️  WARNING: Found sensitive files:" -ForegroundColor Red
        $files | ForEach-Object { Write-Host "    - $($_.FullName)" -ForegroundColor Red }
        $foundSensitive = $true
    }
}
if (-not $foundSensitive) {
    Write-Host "  ✅ No sensitive files found" -ForegroundColor Green
}

Write-Host ""
Write-Host "✅ Analysis complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📖 Next steps:" -ForegroundColor Cyan
Write-Host "  1. Review COMMIT_DIAGNOSIS_AND_ACTION_PLAN.md for detailed plan" -ForegroundColor White
Write-Host "  2. Manually organize documentation files (see suggestions above)" -ForegroundColor White
Write-Host "  3. Stage and commit changes in logical groups" -ForegroundColor White
Write-Host "  4. Push to GitHub: git push origin main" -ForegroundColor White
Write-Host ""



