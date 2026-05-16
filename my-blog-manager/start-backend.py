import sys
import os

# 添加项目根目录到路径
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))

from cms_core.main import app
import uvicorn

if __name__ == "__main__":
    print("Starting backend API on port 8081...")
    uvicorn.run(app, host="127.0.0.1", port=8081, log_level="info")
