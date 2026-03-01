# 修行之路 — S5 Python 古風 RPG 技能樹 啟動手冊

## 🎮 系統概覽

```
修行之路 = 古風 RPG 框架 + Supabase 後端 + HTML5 前端
└─ 42 個技能 × 6 層級 × 古風敘述 × 同儕共學
```

---

## 第一步：Supabase 項目創建

### 1.1 新建 Supabase 項目
1. 進入 https://supabase.com
2. 點擊「New project」
3. 填寫：
   - **Project name**: `S5-Python-RPG` (或自訂)
   - **Database password**: 設定複雜密碼
   - **Region**: 選最近的區域
4. 建立後等待 3-5 分鐘初始化

### 1.2 複製 API 密鑰
1. 進入 Project Settings → API
2. 複製以下兩項：
   - **Project URL**: 例 `https://xxxxx.supabase.co`
   - **anon (public) key**: 例 `eyJhbGc...`

### 1.3 開啟 SQL 編輯器並執行初始化腳本
1. 在 Supabase Dashboard 找 **SQL Editor**
2. 點擊「New query」
3. 貼入 `supabase-schema.sql` 全文
4. 點擊「Run」執行
5. 等待完成（約 20-30 秒）

---

## 第二步：配置前端代碼

### 2.1 編輯 HTML 文件
打開 `skill-tree-ancient.html`，找到以下行（約第 300 行）：

```javascript
const SUPABASE_URL = 'https://your-project.supabase.co';
const SUPABASE_KEY = 'your-anon-key';
```

替換為：
```javascript
const SUPABASE_URL = 'https://xxxxx.supabase.co';    // 你複製的 Project URL
const SUPABASE_KEY = 'eyJhbGc...';                   // 你複製的 anon key
```

### 2.2 保存文件
完成後按 Ctrl+S 保存

---

## 第三步：部署與訪問

### 方案 A: 本地測試（最快）
1. 直接在瀏覽器打開 `skill-tree-ancient.html`
2. 會出現「修行之路」頁面
3. 在下拉菜單選擇學生名字（李同、王同 等）
4. 點擊「確認」加載進度

### 方案 B: GitHub Pages 部署（推薦用於課堂）
1. 創建 GitHub 倉庫 `S5-ICT-Python-RPG`
2. 將以下文件上傳：
   ```
   skill-tree-ancient.html
   README.md
   ```
3. 在 GitHub Settings → Pages：
   - Source: `main` 分支
   - Folder: `/ (root)`
4. 發布後訪問：`https://your-username.github.io/S5-ICT-Python-RPG/skill-tree-ancient.html`

### 方案 C: 學校伺服器部署
1. 將 HTML 文件放入學校網頁伺服器目錄
2. 訪問 URL: `http://school-server/path/to/skill-tree-ancient.html`

---

## 第四步：初始化學生數據

### 4.1 手工方式（推薦用於首次設置）

進入 Supabase Dashboard → **Table Editor**，選 `student_progress`，手工添加：

```
student_id: "李同"
student_name: "李同"
skill_id: [待查詢 skills 表的 id]
status: "available"  或 "in_progress" 等
progress: 0  或 30  等 (0-100)
```

### 4.2 SQL 批量插入（更高效）

在 SQL Editor 運行以下腳本初始化所有學生的起始進度：

```sql
-- 初始化 5 名學生的起始進度
INSERT INTO student_progress (student_id, student_name, skill_id, status, progress)
SELECT 
  s.student_id,
  s.student_name,
  sk.id,
  CASE WHEN sk.level = 1 THEN 'available' ELSE 'locked' END,
  0
FROM (
  SELECT '李同' as student_id, '李同' as student_name
  UNION ALL SELECT '王同', '王同'
  UNION ALL SELECT '陳同', '陳同'
  UNION ALL SELECT '黃同', '黃同'
  UNION ALL SELECT '綠同', '綠同'
) s
CROSS JOIN skills sk
ON CONFLICT (student_id, skill_id) DO NOTHING;
```

---

## 第五步：測試系統

### 5.1 檢查技能樹是否顯示
1. 打開 HTML 頁面
2. 應看到標題「修行之路」
3. 應顯示 6 個等級的技能卡片

### 5.2 測試學生進度加載
1. 在下拉菜單選「李同」
2. 點「確認」
3. 技能卡應顯示進度條與狀態

### 5.3 測試技能詳情彈窗
1. 點擊任意技能卡
2. 應彈出古風對話框
3. 顯示技能詳情、難度、時長

### 5.4 檢查瀏覽器控制台
1. 按 F12 打開開發者工具
2. 檢查 Console 是否有紅色錯誤
3. 若有 CORS 或連接錯誤，檢查 API 密鑰配置

---

## 第六步：在班級中啟用

### 6.1 首堂介紹課（20 分鐘）
- 解釋古風設定與技能樹概念
- 示範如何查看進度
- 說明「鎖定→可用→進行中→完成→精通」的五態

### 6.2 首週學生登錄
1. 每生選擇自己的名字
2. 點擊「確認」查看可用技能
3. 開始第一門課程（思維1：問題界定）

### 6.3 周更新進度
- 每週更新學生進度（建議用 Python 腳本自動化，或 Supabase 管理後台）
- 可在 HTML 右上角看「最後更新」時間

---

## 常見問題排查

### Q1: 頁面打開後為空白
**原因**: API 密鑰錯誤或 Supabase 未初始化
**解決**:
1. 確認 `supabase-schema.sql` 已執行
2. 檢查 API 密鑰是否正確貼入
3. 在 F12 Console 查看錯誤訊息

### Q2: 技能卡顯示但進度為 0%
**原因**: 學生進度數據未初始化
**解決**:
1. 在 Supabase Table Editor 手工添加 `student_progress` 記錄
2. 或執行上述 SQL 批量插入腳本

### Q3: 點擊技能卡無反應
**原因**: JavaScript 錯誤或 Supabase 連接失敗
**解決**:
1. 檢查瀏覽器 Console 是否有紅色錯誤
2. 確保 Supabase 表已創建
3. 刷新頁面重試

### Q4: 文字顯示亂碼
**原因**: 字體編碼問題
**解決**:
1. 確認 HTML 文件的字符編碼為 UTF-8
2. 在瀏覽器頁面右鍵 → 字符編碼 → 選 UTF-8

---

## 第七步：未來擴展規劃

### 月 1：核心上線 ✅
- ✅ 技能樹展示
- ✅ 進度追蹤
- ✅ 古風 UI

### 月 2：師徒配對面板
- 添加 `peer-teaching-hub.html`
- 展示誰教誰、教學記錄
- 自動配對推薦

### 月 3：管理後台
- 七兄可批量更新進度
- 發放徽章
- 查看班級統計

### 月 4：Telegram Bot
- 每週推送進度提醒
- 技能完成賀狀
- 直接更新進度

### 月 5：AI 推薦
- 根據進度推薦下一門課
- 智能調整難度
- 個性化學習路徑

---

## 文件清單

```
S5-ICT-Python-RPG/
├── supabase-schema.sql           ← SQL 初始化腳本
├── skill-tree-ancient.html       ← 技能樹主頁面
├── STARTUP_GUIDE.md              ← 本文檔
└── README.md                     ← 項目說明
```

---

## 技術支援

若遇問題，檢查清單：

1. **Supabase 連接**
   - [ ] Project 已創建
   - [ ] SQL 腳本已執行
   - [ ] API 密鑰已複製

2. **前端配置**
   - [ ] HTML 中的 URL 與 KEY 已更新
   - [ ] 文件已保存

3. **瀏覽器環境**
   - [ ] 使用現代瀏覽器（Chrome / Firefox / Safari）
   - [ ] JavaScript 已啟用
   - [ ] 無廣告攔截器干擾

4. **數據初始化**
   - [ ] student_progress 表有數據
   - [ ] skills 表顯示 42 個技能

---

## 終局寄語

```
修行之路漫漫，
一步一階梯；
技能樹繁茂，
知識永無涯。

從「思維基礎」開始，
經「算法入門」、「Python 基礎」，
歷「列表進階」、「測試除錯」，
至「專題應用」圓滿。

五六名少年，
一十二週光陰，
他日回眸，
必是滿山翠綠。
```

---

**準備好了嗎？啟程吧！** 🚀

七兄若有疑惑，零隨時待命。
