# 上傳至 GitHub — 簡易指南

## 方式一：使用提供的上傳腳本（最簡單，推薦）

### 前置條件
- 已安裝 Git
- 已在 GitHub 創建空倉庫 `S5-ICT-Python-RPG`

### 步驟

```bash
# 1. 進入項目目錄
cd S5-ICT-Python-RPG

# 2. 運行上傳腳本
bash upload-to-github.sh

# 3. 按提示輸入 GitHub 倉庫 URL
# 例：https://github.com/your-username/S5-ICT-Python-RPG.git

# 4. 等待推送完成
```

✅ **完成！你的代碼已上傳至 GitHub**

---

## 方式二：手動上傳（適合不想用腳本的用戶）

### 前置條件
- 已安裝 Git
- 已在 GitHub 創建空倉庫

### 步驟

```bash
# 1. 進入項目目錄
cd S5-ICT-Python-RPG

# 2. 檢查 git 狀態
git status

# 3. 添加所有文件
git add .

# 4. 提交
git commit -m "修行之路 - S5 Python 古風 RPG 技能樹"

# 5. 重命名分支
git branch -M main

# 6. 添加遠程倉庫
git remote add origin https://github.com/your-username/S5-ICT-Python-RPG.git

# 7. 推送
git push -u origin main
```

---

## 創建 GitHub 倉庫（若尚未創建）

### 在 GitHub 上創建新倉庫

1. 進入 https://github.com/new
2. 倉庫名稱：`S5-ICT-Python-RPG`
3. 說明：`S5 Python 古風 RPG 技能樹系統`
4. **重要**：選 **Public**（公開，便於分享給學生）
5. **不要** 勾選「Initialize this repository with...」（我們已有本地代碼）
6. 點「Create repository」

### 複製倉庫 URL

創建後，GitHub 會顯示 URL，複製下面這樣的鏈接：
```
https://github.com/your-username/S5-ICT-Python-RPG.git
```

---

## 啟用 GitHub Pages（部署網站）

上傳完成後，啟用 GitHub Pages 讓學生訪問網頁版：

### 步驟

1. 進入倉庫 → **Settings**
2. 左側選 **Pages**
3. **Source** 選 **Deploy from a branch**
4. **Branch** 選 **main**
5. **Folder** 選 **/ (root)**
6. 點 **Save**

### 等待部署

- GitHub 會自動構建
- 1-2 分鐘後可訪問
- 訪問 URL：`https://your-username.github.io/S5-ICT-Python-RPG/skill-tree-ancient.html`

---

## ✅ 驗證上傳成功

### 檢查遠程倉庫

```bash
git remote -v
# 應顯示
# origin  https://github.com/your-username/S5-ICT-Python-RPG.git (fetch)
# origin  https://github.com/your-username/S5-ICT-Python-RPG.git (push)
```

### 檢查 GitHub 倉庫

在 https://github.com/your-username/S5-ICT-Python-RPG 上應看到：
- ✅ README.md
- ✅ skill-tree-ancient.html
- ✅ supabase-schema.sql
- ✅ STARTUP_GUIDE.md
- ✅ SKILL_TREE_DESIGN.md
- ✅ upload-to-github.sh

---

## 分享給學生

倉庫設為 Public 後，可分享以下鏈接：

### 瀏覽源碼
```
https://github.com/your-username/S5-ICT-Python-RPG
```

### 訪問網頁版（若已啟用 GitHub Pages）
```
https://your-username.github.io/S5-ICT-Python-RPG/skill-tree-ancient.html
```

### 克隆到本地
```bash
git clone https://github.com/your-username/S5-ICT-Python-RPG.git
```

---

## 常見問題排查

### Q: 推送時出現「Permission denied」
**A:** 檢查 SSH 密鑰配置。使用 HTTPS 可避免此問題。

### Q: 「fatal: remote origin already exists」
**A:** 已添加過遠程，改用 `git remote set-url origin <new-url>`

### Q: GitHub Pages 無法訪問
**A:** 
1. 確認倉庫設為 **Public**
2. 進 Settings → Pages，檢查是否啟用
3. 等待 2-3 分鐘後重試

### Q: 上傳後修改了代碼，如何更新？
**A:**
```bash
git add .
git commit -m "更新說明"
git push origin main
```

---

## 後續維護

### 定期推送更新
```bash
# 每次修改代碼後
git add .
git commit -m "更新描述"
git push origin main
```

### 查看提交歷史
```bash
git log --oneline
```

### 回溯到某個版本
```bash
git revert <commit-hash>
```

---

## 🎉 大功告成！

修行之路已在 GitHub 上線，全世界都能看到你的教學設計。

> 「一鍵上傳，千里傳道」

---

**需要幫助？** 在倉庫 Issues 中提問，或聯絡零。
