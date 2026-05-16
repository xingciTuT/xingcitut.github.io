# 星辉云端控制台启动脚本
$ErrorActionPreference = "Stop"

# 设置编码
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

# 项目目录
$ProjectDir = "K:\XINGCI\XinghuisamaBlogs-main\my-blog-manager"
Set-Location $ProjectDir

# 查找并结束旧的进程
Write-Host "正在清理旧进程..." -ForegroundColor Yellow
Get-Process -Name "python" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like "*start-backend*" } | Stop-Process -Force
Get-Process -Name "node" -ErrorAction SilentlyContinue | Where-Object { $_.CommandLine -like "*next*" } | Stop-Process -Force
Start-Sleep 2

# 启动后端 API
Write-Host "正在启动后端 API (端口 8081)..." -ForegroundColor Green
$backend = Start-Process -FilePath "python" -ArgumentList "start-backend.py" -WorkingDirectory $ProjectDir -WindowStyle Hidden -PassThru

# 等待后端启动
$retry = 0
while ($retry -lt 30) {
    try {
        $response = Invoke-WebRequest -Uri "http://127.0.0.1:8081/api/status" -Method GET -TimeoutSec 2 -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-Host "后端 API 启动成功！" -ForegroundColor Green
            break
        }
    } catch {
        Start-Sleep 1
        $retry++
    }
}

if ($retry -ge 30) {
    Write-Host "后端启动失败！" -ForegroundColor Red
    exit 1
}

# 启动前端开发服务器
Write-Host "正在启动前端开发服务器..." -ForegroundColor Green
$frontend = Start-Process -FilePath "npm" -ArgumentList "run","dev" -WorkingDirectory $ProjectDir -WindowStyle Hidden -PassThru

# 等待前端启动
$retry = 0
while ($retry -lt 30) {
    try {
        $response = Invoke-WebRequest -Uri "http://localhost:3000" -Method GET -TimeoutSec 2 -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-Host "前端启动成功！" -ForegroundColor Green
            break
        }
    } catch {
        Start-Sleep 1
        $retry++
    }
}

if ($retry -ge 30) {
    Write-Host "前端启动失败！" -ForegroundColor Red
    exit 1
}

# 打开浏览器
Write-Host "正在打开浏览器..." -ForegroundColor Cyan
Start-Process "http://localhost:3000"

Write-Host "`n=============================================" -ForegroundColor Cyan
Write-Host "  星辉云端控制台已启动！" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "  前端面板: http://localhost:3000" -ForegroundColor White
Write-Host "  后端 API: http://127.0.0.1:8081" -ForegroundColor White
Write-Host "  管理后台: http://localhost:3000/admin" -ForegroundColor White
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "`n按任意键停止所有服务..." -ForegroundColor Yellow
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

# 停止进程
Write-Host "`n正在停止服务..." -ForegroundColor Yellow
Stop-Process -Id $backend.Id -Force -ErrorAction SilentlyContinue
Stop-Process -Id $frontend.Id -Force -ErrorAction SilentlyContinue
Write-Host "服务已停止！" -ForegroundColor Green
