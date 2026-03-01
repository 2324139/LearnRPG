#!/bin/bash
# 修行之路 — GitHub 上傳腳本
# 使用方式：bash upload-to-github.sh

set -e

echo "🎮 修行之路 - GitHub 上傳啟動"
echo "================================"
echo ""

# 檢查 git 是否已安裝
if ! command -v git &> /dev/null; then
    echo "❌ 未找到 git，請先安裝 git"
    exit 1
fi

# 檢查是否已初始化 git
if [ ! -d ".git" ]; then
    echo "❌ 未在 git 倉庫中，請先執行 git init"
    exit 1
fi

# 輸入 GitHub 倉庫 URL
read -p "請輸入你的 GitHub 倉庫 URL (格式: https://github.com/username/S5-ICT-Python-RPG.git): " REPO_URL

if [ -z "$REPO_URL" ]; then
    echo "❌ 倉庫 URL 不能為空"
    exit 1
fi

# 添加遠程倉庫
echo ""
echo "📍 添加遠程倉庫..."
git remote add origin "$REPO_URL" 2>/dev/null || git remote set-url origin "$REPO_URL"

# 重命名分支為 main（GitHub 新默認）
echo "🌳 重命名分支為 main..."
git branch -M main

# 推送到 GitHub
echo ""
echo "🚀 推送至 GitHub..."
git push -u origin main

echo ""
echo "✅ 上傳成功！"
echo ""
echo "你的倉庫已發佈至："
echo "$REPO_URL"
echo ""
echo "若要啟用 GitHub Pages（建議）："
echo "1. 進入倉庫 Settings → Pages"
echo "2. Source 選 'Deploy from a branch'"
echo "3. Branch 選 'main' / 'root' 目錄"
echo "4. 等待 1-2 分鐘，訪問 https://username.github.io/S5-ICT-Python-RPG/skill-tree-ancient.html"
echo ""
echo "🎉 修行之路已上線！"
