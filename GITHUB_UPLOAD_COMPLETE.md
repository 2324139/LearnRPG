# 📤 修行之路 — GitHub 上傳完整指南

## 🎯 目標

將本地的 S5-ICT-Python-RPG 項目上傳至 GitHub，讓全班學生都能訪問。

---

## 🔑 前置條件（必備）

### 1. 安裝 Git
- **Windows**: 下載 https://git-scm.com/download/win
- **Mac**: `brew install git` 或下載 https://git-scm.com/download/mac
- **Linux**: `sudo apt install git`

驗證安裝：
```bash
git --version
```

### 2. 創建 GitHub 帳號
- 進 https://github.com
- 點「Sign up」
- 填寫用戶名、郵箱、密碼
- 驗證郵箱
- ✅ 完成

### 3. 本地已有項目代碼
- ✅ 已有 `S5-ICT-Python-RPG` 文件夾
- ✅ 內含所有必要文件

---

## 📋 第一步：在 GitHub 創建新倉庫（3 分鐘）

### 1.1 登入 GitHub
進 https://github.com，點右上角頭像 → **New repository**

### 1.2 填寫倉庫信息

| 欄位 | 內容 |
|------|------|
| **Repository name** | `S5-ICT-Python-RPG` |
| **Description** | `修行之路：S5 Python 古風 RPG 技能樹系統` |
| **Public** | ✅ 勾選（讓學生能訪問） |
| **Initialize this repository** | ⬜ 不勾選（我們已有本地代碼） |

### 1.3 點「Create repository」

稍等 1-2 秒，GitHub 會顯示倉庫已創建。

### 1.4 複製倉庫 URL

創建後，你會看到一個頁面。找到綠色「Code」按鈕，點下去。

在「Clone」下複製 HTTPS URL（推薦）：
```
https://github.com/your-username/S5-ICT-Python-RPG.git
```

**記下這個 URL，後面會用到！**

---

## 🚀 第二步：上傳本地代碼（5 分鐘）

### 方式 A: 使用終端機（推薦，最快）

#### Mac / Linux 用戶

1. 打開終端 (Terminal)
2. 進入項目文件夾：
```bash
cd /path/to/S5-ICT-Python-RPG
```

3. 運行上傳腳本：
```bash
bash upload-to-github.sh
```

4. 按提示輸入 GitHub 倉庫 URL（從步驟 1.4 複製）
5. 稍等，推送完成

#### Windows 用戶

1. 進入項目文件夾 `S5-ICT-Python-RPG`
2. 在空白處右鍵 → **Git Bash Here**
3. 複製粘貼以下命令：
```bash
git init
git add .
git commit -m "Initial commit: 修行之路 RPG 技能樹系統"
git branch -M main
git remote add origin https://github.com/your-username/S5-ICT-Python-RPG.git
git push -u origin main
```
（記得替換 URL 中的 `your-username`）

4. 按 Enter 執行
5. 稍等，推送完成

### 方式 B: 不使用終端（適合不熟悉命令行的用戶）

GitHub 提供了網頁版上傳工具。進倉庫頁面 → 點「Add file」→「Upload files」

但這種方式不保留 Git 歷史，**不推薦**。

---

## ✅ 第三步：驗證上傳成功（2 分鐘）

### 3.1 檢查 GitHub 倉庫

進 https://github.com/your-username/S5-ICT-Python-RPG

應看到這些文件：
- ✅ README.md
- ✅ skill-tree-ancient.html
- ✅ supabase-schema.sql
- ✅ STARTUP_GUIDE.md
- ✅ SKILL_TREE_DESIGN.md
- ✅ upload-to-github.sh
- ✅ GITHUB_UPLOAD_GUIDE.md

### 3.2 查看提交歷史

點「Commits」，應看到你的提交記錄（如「Initial commit」等）

---

## 🌍 第四步：啟用 GitHub Pages（2 分鐘）

讓學生能直接訪問網頁版，無需下載代碼。

### 4.1 進倉庫設置

倉庫頁面 → **Settings** 左側選 **Pages**

### 4.2 配置 Pages

| 選項 | 設定 |
|------|------|
| **Source** | Deploy from a branch |
| **Branch** | main |
| **Folder** | / (root) |

點「Save」

### 4.3 等待發佈

GitHub 會自動構建網站，1-2 分鐘後完成。

頁面上方會顯示：
> Your site is live at https://your-username.github.io/S5-ICT-Python-RPG/

---

## 📱 第五步：分享給學生（1 分鐘）

### 倉庫源碼

學生可瀏覽完整代碼：
```
https://github.com/your-username/S5-ICT-Python-RPG
```

### 技能樹網頁版（推薦分享此鏈接）

學生可直接訪問修行之路：
```
https://your-username.github.io/S5-ICT-Python-RPG/skill-tree-ancient.html
```

**短鏈接生成**（可選）：
- 使用 https://bit.ly 或 https://tinyurl.com
- 貼入上面的 GitHub Pages URL
- 生成短鏈，在課堂分享

### 粘貼方式

- **課室 Teams / Google Classroom**：直接貼鏈接
- **QR Code**：用 https://qr-code-generator.com 生成 QR Code
- **班級 WhatsApp**：分享短鏈接

---

## 🔄 第六步：後續更新（按需）

若日後修改了代碼（如修正錯誤、添加新功能），可這樣更新：

```bash
cd /path/to/S5-ICT-Python-RPG

# 添加修改
git add .

# 提交修改
git commit -m "修改描述，例：修復 Bug / 添加新技能"

# 推送至 GitHub
git push origin main
```

GitHub Pages 會自動更新。

---

## ⚠️ 常見問題排查

### Q1: 推送時出現「fatal: not a git repository」
**A:** 未在正確目錄運行。確認當前目錄是 `S5-ICT-Python-RPG`，用 `pwd` 檢查路徑。

### Q2: 「Permission denied (publickey)」錯誤
**A:** SSH 密鑰未配置。建議使用 HTTPS 鏈接而非 SSH。
```bash
git remote set-url origin https://github.com/your-username/S5-ICT-Python-RPG.git
```

### Q3: 「fatal: remote origin already exists」
**A:** 遠程已添加。改用：
```bash
git remote set-url origin https://github.com/your-username/S5-ICT-Python-RPG.git
```

### Q4: GitHub Pages 網頁無法訪問（404）
**A:**
1. 確認倉庫 **Public**
2. 檢查 Settings → Pages 是否已啟用
3. 等待 2-3 分鐘重試（構建需時間）
4. 清除瀏覽器快取（Ctrl+Shift+Delete）

### Q5: 倉庫有敏感信息（如 API 密鑰）
**A:** 立即編輯 `.env` 或 `.gitignore` 移除它，然後：
```bash
git rm --cached .env
git commit -m "Remove sensitive data"
git push origin main
```

### Q6: 想刪除倉庫
**A:** 倉庫頁面 → Settings → Danger Zone → Delete repository

---

## 📚 補充資料

### Git 常用命令速查

| 命令 | 作用 |
|------|------|
| `git status` | 查看修改狀態 |
| `git log --oneline` | 查看提交歷史 |
| `git diff` | 查看改變詳情 |
| `git branch -M main` | 重命名分支 |
| `git remote -v` | 查看遠程倉庫 |

### GitHub 進階功能（可選）

- **Wiki**: 補充文檔
- **Discussions**: 班級討論
- **Issues**: 收集反饋或 Bug 報告
- **Projects**: 進度管理

---

## 🎉 大功告成！

修行之路已在 GitHub 上線，全班學生都能訪問。

**分享鏈接：**
```
https://your-username.github.io/S5-ICT-Python-RPG/skill-tree-ancient.html
```

> 「一鍵上傳，千里傳道；修行無始，唯志不懈」

---

**需要幫助？** 
- 查詢 [GitHub 官方文檔](https://docs.github.com)
- 或在倉庫 Issues 中提問

祝上傳順利！ 🚀
