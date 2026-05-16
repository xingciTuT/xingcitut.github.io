@echo off
chcp 65001 >nul
cd /d "%~dp0"

echo ==========================================
echo  星辉云端控制台启动器
echo ==========================================
echo.

REM 清理旧进程
echo [1/4] 正在清理旧进程...
taskkill /F /IM python.exe /FI "WINDOWTITLE eq *start-backend*" 2>nul
taskkill /F /IM node.exe 2>nul
timeout /t 2 /nobreak >nul

REM 启动后端
echo [2/4] 正在启动后端 API (端口 8081)...
start "Backend API" python start-backend.py

REM 等待后端启动
echo [3/4] 等待后端启动...
:wait_backend
timeout /t 1 /nobreak >nul
curl -s http://127.0.0.1:8081/api/status >nul 2>&1
if errorlevel 1 goto wait_backend
echo 后端 API 启动成功！

REM 启动前端
echo [4/4] 正在启动前端开发服务器...
start "Frontend" npm run dev

REM 等待前端启动
echo 等待前端启动...
:wait_frontend
timeout /t 1 /nobreak >nul
curl -s http://localhost:3000 >nul 2>&1
if errorlevel 1 goto wait_frontend
echo 前端启动成功！

echo.
echo ==========================================
echo  星辉云端控制台已启动！
echo ==========================================
echo  前端面板: http://localhost:3000
echo  后端 API: http://127.0.0.1:8081
echo  管理后台: http://localhost:3000/admin
echo ==========================================
echo.
echo 正在打开浏览器...
start http://localhost:3000

echo.
echo 按任意键停止所有服务...
pause >nul

echo.
echo 正在停止服务...
taskkill /F /IM python.exe /FI "WINDOWTITLE eq Backend API" 2>nul
taskkill /F /IM node.exe /FI "WINDOWTITLE eq Frontend" 2>nul
echo 服务已停止！
pause
