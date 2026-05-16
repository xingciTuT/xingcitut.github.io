@echo off
chcp 65001 >nul
cd /d "%~dp0"
echo ==========================================
echo  星辉云端控制台 - 本地管理面板
echo ==========================================
echo.
echo 正在启动后端 API (端口 8080)...
start "后端API" python -c "from cms_core.main import app; import uvicorn; uvicorn.run(app, host='127.0.0.1', port=8080, log_level='info')"
echo 后端 API 已启动: http://127.0.0.1:8080
echo.
echo 正在启动前端开发服务器...
start "前端面板" npm run dev
echo 前端面板地址: http://localhost:3000
echo.
echo ==========================================
echo 请打开浏览器访问: http://localhost:3000
echo API 地址: http://127.0.0.1:8080
echo ==========================================
pause
