# 强制切换到脚本所在目录
Set-Location $PSScriptRoot

# 遇到错误即停止
$ErrorActionPreference = "Stop"

Write-Host "--- [Sub-Project Sync] Directory: $(Get-Location) ---" -ForegroundColor Gray

# 强制刷新子仓库的远程信息
Write-Host "Fetching Sub-repo..." -ForegroundColor Cyan
git fetch --all --prune

# 暂存子仓库本地改动
Write-Host "Stashing local changes in Sub-repo..." -ForegroundColor Cyan
git stash

# 拉取子仓库代码
Write-Host "Pulling latest main..." -ForegroundColor Cyan
try {
    # 显式指定拉取 origin 的 main 分支
    git pull origin main
    Write-Host "Sub-repo Pull successful!" -ForegroundColor Green
}
catch {
    Write-Host "Pull failed! Please check if this directory is a Git repo." -ForegroundColor Red
}

# 恢复子仓库本地改动
Write-Host "Restoring local changes..." -ForegroundColor Cyan
$hasStash = git stash list
if ($hasStash) {
    git stash pop
    Write-Host "Local changes restored." -ForegroundColor Green
}

Write-Host "--- Sub-repo Sync Complete ---`n" -ForegroundColor Magenta