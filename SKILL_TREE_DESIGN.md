# S5 Python RPG 技能樹系統設計

## 總體架構

```
╔════════════════════════════════════════════════════════════════╗
║            S5 Python 修行之路 — RPG 技能樹                      ║
╠════════════════════════════════════════════════════════════════╣
║                                                                ║
║  Supabase (後端數據)                                           ║
║  ├─ skills (技能定義)                                         ║
║  ├─ student_progress (學生進度)                                ║
║  ├─ skill_dependencies (前置關係)                              ║
║  ├─ peer_teachers (導師配對)                                   ║
║  └─ achievements (徽章系統)                                    ║
║                                                                ║
║  前端展示層                                                    ║
║  ├─ 技能樹可視化 (互動式 SVG)                                  ║
║  ├─ 個人進度卡 (角色卡)                                        ║
║  ├─ 師徒配對面板                                               ║
║  └─ 全班冒險地圖                                               ║
║                                                                ║
║  未來擴展                                                      ║
║  ├─ Telegram Bot (推播提醒)                                    ║
║  ├─ GitHub Integration (代碼同步)                              ║
║  ├─ AI 推薦引擎 (下一步技能)                                   ║
║  └─ 積分交易系統 (兌換獎勵)                                    ║
║                                                                ║
╚════════════════════════════════════════════════════════════════╝
```

---

## 第一步：技能樹完整映射（DCH1-6 → RPG 技能）

### 等級架構
```
Lv1: 思維基礎 (DCH1)
  ├─ [思維1] 問題界定 (6何法)
  ├─ [思維2] IPO 模型
  ├─ [思維3] 問題拆解
  ├─ [思維4] 模式識別
  ├─ [思維5] 抽象化概念
  └─ [思維6] UI 設計

Lv2: 算法入門 (DCH2-3)
  ├─ [算法1] 偽代碼 [前置: 思維6]
  ├─ [算法2] 流程圖 [前置: 思維6]
  ├─ [算法3] 變量與賦值 [前置: 算法1]
  ├─ [算法4] 數據類型 [前置: 算法3]
  ├─ [算法5] if-else [前置: 算法4]
  ├─ [算法6] 陣列概念 [前置: 算法4]
  ├─ [算法7] 加總與平均 [前置: 算法6]
  ├─ [算法8] 線性檢索 [前置: 算法6]
  ├─ [算法9] 最大最小值 [前置: 算法6]
  └─ [算法10] 排序檢查 [前置: 算法9]

Lv3: Python 基礎 (DCH4)
  ├─ [Python1] 變量宣告 [前置: 算法3]
  ├─ [Python2] 數據類型轉換 [前置: Python1]
  ├─ [Python3] 輸入輸出 [前置: Python2]
  ├─ [Python4] 運算符 [前置: Python1]
  ├─ [Python5] 關係運算 [前置: Python4]
  ├─ [Python6] if 語句 [前置: 算法5, Python3]
  ├─ [Python7] 布爾邏輯 [前置: Python6]
  ├─ [Python8] for 迴圈 [前置: Python3]
  ├─ [Python9] while 迴圈 [前置: Python8]
  ├─ [Python10] 內置函數 [前置: Python3]
  └─ [Python11] 數學與隨機庫 [前置: Python10]

Lv4: 列表與進階 (DCH5)
  ├─ [進階1] 列表基礎 [前置: 算法6, Python8]
  ├─ [進階2] 列表索引 [前置: 進階1]
  ├─ [進階3] 列表遍歷 [前置: 進階2, Python8]
  ├─ [進階4] 列表方法 [前置: 進階3]
  ├─ [進階5] 字串處理 [前置: Python3]
  ├─ [進階6] 字串切片 [前置: 進階5]
  ├─ [進階7] 函數定義 [前置: Python10]
  ├─ [進階8] 函數參數 [前置: 進階7]
  └─ [進階9] 綜合解難 [前置: 進階4, 進階8, Python9]

Lv5: 測試與除錯 (DCH6)
  ├─ [測試1] 測試概念 [前置: 思維6]
  ├─ [測試2] 語法錯誤排查 [前置: Python3]
  ├─ [測試3] 運行時錯誤 [前置: 測試2]
  ├─ [測試4] 邏輯錯誤 [前置: 算法1]
  ├─ [測試5] 測試數據設計 [前置: 測試1, 思維1]
  ├─ [測試6] 空運行與追蹤 [前置: 測試4]
  └─ [測試7] 除錯技巧 [前置: 測試6]

Lv6: 專題應用 (自設)
  ├─ [專題1] 爬蟲基礎 [前置: 進階4, Python9]
  ├─ [專題2] 檔案 I/O [前置: 進階7, Python3]
  ├─ [專題3] 資料視覺化 [前置: 進階4, 測試7]
  ├─ [專題4] 微型應用設計 [前置: 進階9, 專題1]
  └─ [專題5] 期末專題 [前置: 專題2, 專題3, 專題4]
```

---

## 第二步：Supabase 數據庫結構

### 表 1: `skills` (技能定義)

```sql
CREATE TABLE skills (
  id BIGINT PRIMARY KEY,
  skill_code TEXT UNIQUE,          -- "Python1", "進階5", etc
  skill_name TEXT NOT NULL,        -- "變量宣告", "字串處理", etc
  level INT NOT NULL,              -- 1-6
  description TEXT,                -- 技能說明
  learning_resources TEXT[],       -- ["DCH4:4.2", "https://..."]
  difficulty INT,                  -- 1-5 (難度星級)
  estimated_hours FLOAT,           -- 預計學習時長
  created_at TIMESTAMP DEFAULT NOW()
);
```

### 表 2: `skill_dependencies` (前置關係)

```sql
CREATE TABLE skill_dependencies (
  id BIGINT PRIMARY KEY,
  skill_id BIGINT NOT NULL REFERENCES skills(id),
  prerequisite_id BIGINT NOT NULL REFERENCES skills(id),
  is_strict BOOLEAN DEFAULT FALSE, -- true = 必學，false = 建議
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(skill_id, prerequisite_id)
);
```

### 表 3: `student_progress` (學生進度)

```sql
CREATE TABLE student_progress (
  id BIGINT PRIMARY KEY,
  student_id TEXT NOT NULL,        -- "李同", "王同", etc
  skill_id BIGINT NOT NULL REFERENCES skills(id),
  status TEXT DEFAULT 'locked',    -- 'locked' / 'available' / 'in_progress' / 'completed' / 'mastered'
  progress INT DEFAULT 0,          -- 0-100%
  attempts INT DEFAULT 0,          -- 嘗試次數
  quiz_score INT,                  -- 小測分數 (0-100)
  completed_at TIMESTAMP,
  last_updated_at TIMESTAMP DEFAULT NOW(),
  notes TEXT,                       -- 學生自註
  UNIQUE(student_id, skill_id)
);
```

### 表 4: `peer_teachers` (導師配對)

```sql
CREATE TABLE peer_teachers (
  id BIGINT PRIMARY KEY,
  teacher_id TEXT NOT NULL,        -- 導師
  student_id TEXT NOT NULL,        -- 學生
  skill_id BIGINT NOT NULL REFERENCES skills(id),
  month INT,                       -- 1-12 (月份)
  session_count INT DEFAULT 0,     -- 教學次數
  feedback_score INT,              -- 1-5 (被教者評分)
  created_at TIMESTAMP DEFAULT NOW()
);
```

### 表 5: `achievements` (徽章系統)

```sql
CREATE TABLE achievements (
  id BIGINT PRIMARY KEY,
  achievement_code TEXT UNIQUE,    -- "除錯獵人", "知識分享者", etc
  achievement_name TEXT NOT NULL,
  description TEXT,
  icon_url TEXT,                   -- 徽章圖示
  criteria TEXT,                   -- 達成條件 (JSON)
  reward_points INT DEFAULT 10,    -- 獲得點數
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE student_achievements (
  id BIGINT PRIMARY KEY,
  student_id TEXT NOT NULL,
  achievement_id BIGINT NOT NULL REFERENCES achievements(id),
  earned_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(student_id, achievement_id)
);
```

### 表 6: `learning_logs` (學習日誌)

```sql
CREATE TABLE learning_logs (
  id BIGINT PRIMARY KEY,
  student_id TEXT NOT NULL,
  skill_id BIGINT NOT NULL REFERENCES skills(id),
  action TEXT,                    -- 'started' / 'watched' / 'practiced' / 'passed_quiz' / 'asked_help'
  duration_minutes INT,           -- 該次學習時長
  reflection TEXT,                -- 學習反思
  created_at TIMESTAMP DEFAULT NOW()
);
```

---

## 第三步：前端展示層架構

### 頁面 1: 技能樹可視化 (`skill_tree.html`)

```html
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>S5 Python 修行之路 - 技能樹</title>
  <style>
    body {
      font-family: 'Arial', sans-serif;
      background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
      color: #333;
      padding: 20px;
    }
    .container {
      max-width: 1200px;
      margin: 0 auto;
      background: white;
      border-radius: 15px;
      padding: 30px;
      box-shadow: 0 10px 40px rgba(0,0,0,0.2);
    }
    h1 {
      text-align: center;
      color: #667eea;
      margin-bottom: 30px;
    }
    .skill-tree {
      display: flex;
      flex-direction: column;
      gap: 40px;
    }
    .level {
      border: 2px solid #ddd;
      border-radius: 10px;
      padding: 20px;
      background: #f9f9f9;
    }
    .level-title {
      font-size: 18px;
      font-weight: bold;
      margin-bottom: 15px;
      color: #667eea;
    }
    .skills-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
      gap: 15px;
    }
    .skill-card {
      padding: 15px;
      border-radius: 8px;
      cursor: pointer;
      transition: all 0.3s;
      border: 2px solid #ddd;
      position: relative;
    }
    .skill-card.locked {
      background: #e0e0e0;
      opacity: 0.6;
      color: #666;
    }
    .skill-card.available {
      background: #fff9e6;
      border-color: #ffc107;
    }
    .skill-card.in_progress {
      background: #e3f2fd;
      border-color: #2196f3;
    }
    .skill-card.completed {
      background: #c8e6c9;
      border-color: #4caf50;
    }
    .skill-card.mastered {
      background: #fff59d;
      border-color: #fbc02d;
      box-shadow: 0 0 10px #fbc02d;
    }
    .skill-name {
      font-weight: bold;
      margin-bottom: 5px;
    }
    .skill-code {
      font-size: 12px;
      color: #999;
      margin-bottom: 8px;
    }
    .progress-bar {
      width: 100%;
      height: 8px;
      background: #ddd;
      border-radius: 4px;
      overflow: hidden;
      margin-bottom: 8px;
    }
    .progress-fill {
      height: 100%;
      background: #4caf50;
      transition: width 0.3s;
    }
    .skill-difficulty {
      font-size: 12px;
      margin: 5px 0;
    }
    .star {
      color: #ffc107;
    }
    .prerequisites {
      font-size: 11px;
      color: #666;
      margin-top: 8px;
      padding-top: 8px;
      border-top: 1px solid #ddd;
    }
    .modal {
      display: none;
      position: fixed;
      top: 0;
      left: 0;
      width: 100%;
      height: 100%;
      background: rgba(0,0,0,0.5);
      justify-content: center;
      align-items: center;
      z-index: 1000;
    }
    .modal-content {
      background: white;
      padding: 30px;
      border-radius: 10px;
      width: 90%;
      max-width: 500px;
      max-height: 80vh;
      overflow-y: auto;
    }
    .close {
      float: right;
      font-size: 28px;
      font-weight: bold;
      cursor: pointer;
      color: #aaa;
    }
  </style>
</head>
<body>
  <div class="container">
    <h1>🎮 S5 Python 修行之路</h1>
    <div class="skill-tree" id="skillTree"></div>
  </div>

  <div id="skillModal" class="modal">
    <div class="modal-content">
      <span class="close" onclick="closeModal()">&times;</span>
      <div id="modalBody"></div>
    </div>
  </div>

  <script src="https://cdn.jsdelivr.net/npm/@supabase/supabase-js@2"></script>
  <script>
    // Supabase 初始化
    const SUPABASE_URL = 'https://your-project.supabase.co';
    const SUPABASE_KEY = 'your-anon-key';
    const supabase = window.supabase.createClient(SUPABASE_URL, SUPABASE_KEY);

    let currentStudent = '李同'; // 替換為實際登入用戶
    let skillsData = {};
    let progressData = {};

    // 初始化
    async function initSkillTree() {
      await loadSkills();
      await loadProgress();
      renderTree();
    }

    // 加載技能定義
    async function loadSkills() {
      const { data, error } = await supabase
        .from('skills')
        .select('*')
        .order('level', { ascending: true })
        .order('id', { ascending: true });
      
      if (error) {
        console.error('Error loading skills:', error);
        return;
      }

      data.forEach(skill => {
        skillsData[skill.id] = skill;
      });
    }

    // 加載學生進度
    async function loadProgress() {
      const { data, error } = await supabase
        .from('student_progress')
        .select('*')
        .eq('student_id', currentStudent);
      
      if (error) {
        console.error('Error loading progress:', error);
        return;
      }

      data.forEach(prog => {
        progressData[prog.skill_id] = prog;
      });
    }

    // 渲染技能樹
    function renderTree() {
      const tree = document.getElementById('skillTree');
      tree.innerHTML = '';

      // 按等級分組
      const byLevel = {};
      Object.values(skillsData).forEach(skill => {
        if (!byLevel[skill.level]) byLevel[skill.level] = [];
        byLevel[skill.level].push(skill);
      });

      // 渲染各等級
      Object.keys(byLevel).sort((a, b) => a - b).forEach(level => {
        const levelDiv = document.createElement('div');
        levelDiv.className = 'level';

        const levelTitle = document.createElement('div');
        levelTitle.className = 'level-title';
        levelTitle.textContent = `Lv${level}: ${getLevelName(level)}`;
        levelDiv.appendChild(levelTitle);

        const skillsGrid = document.createElement('div');
        skillsGrid.className = 'skills-grid';

        byLevel[level].forEach(skill => {
          const card = createSkillCard(skill);
          skillsGrid.appendChild(card);
        });

        levelDiv.appendChild(skillsGrid);
        tree.appendChild(levelDiv);
      });
    }

    // 創建技能卡片
    function createSkillCard(skill) {
      const card = document.createElement('div');
      card.className = 'skill-card';

      const progress = progressData[skill.id] || { status: 'locked', progress: 0 };
      card.classList.add(progress.status);

      card.innerHTML = `
        <div class="skill-code">${skill.skill_code}</div>
        <div class="skill-name">${skill.skill_name}</div>
        <div class="progress-bar">
          <div class="progress-fill" style="width: ${progress.progress}%"></div>
        </div>
        <div style="font-size: 12px; color: #666;">${progress.progress}%</div>
        <div class="skill-difficulty">
          難度: ${Array(skill.difficulty).fill('⭐').join('')}
        </div>
        <div class="skill-difficulty">
          約 ${skill.estimated_hours} 小時
        </div>
      `;

      card.onclick = () => showSkillDetail(skill, progress);
      return card;
    }

    // 顯示技能詳情
    function showSkillDetail(skill, progress) {
      const modal = document.getElementById('skillModal');
      const body = document.getElementById('modalBody');

      let statusText = {
        'locked': '🔒 已鎖定 (需先掌握前置技能)',
        'available': '✅ 可開始學習',
        'in_progress': '🚀 學習中',
        'completed': '✓ 已完成',
        'mastered': '⭐ 精通'
      }[progress.status];

      body.innerHTML = `
        <h2>${skill.skill_name}</h2>
        <p><strong>代碼:</strong> ${skill.skill_code}</p>
        <p><strong>狀態:</strong> ${statusText}</p>
        <p><strong>進度:</strong> ${progress.progress}%</p>
        <p><strong>難度:</strong> ${Array(skill.difficulty).fill('⭐').join('')}</p>
        <p><strong>預計時長:</strong> ${skill.estimated_hours} 小時</p>
        <p><strong>說明:</strong> ${skill.description || '暫無說明'}</p>
        <hr>
        <h3>學習資源</h3>
        <ul>
          ${(skill.learning_resources || []).map(r => `<li>${r}</li>`).join('')}
        </ul>
        <hr>
        <h3>我的進度</h3>
        <p>嘗試次數: ${progress.attempts}</p>
        <p>小測成績: ${progress.quiz_score || '未測試'}</p>
        <textarea placeholder="寫下你的學習反思..." style="width: 100%; height: 100px;"></textarea>
        <button onclick="saveReflection(${skill.id})">保存反思</button>
      `;

      modal.style.display = 'flex';
    }

    // 保存學習反思
    async function saveReflection(skillId) {
      const textarea = document.querySelector('textarea');
      const reflection = textarea.value;

      const { error } = await supabase
        .from('learning_logs')
        .insert({
          student_id: currentStudent,
          skill_id: skillId,
          action: 'reflection',
          reflection: reflection
        });

      if (error) {
        console.error('Error saving reflection:', error);
      } else {
        alert('反思已保存！');
        closeModal();
      }
    }

    function closeModal() {
      document.getElementById('skillModal').style.display = 'none';
    }

    function getLevelName(level) {
      const names = {
        1: '思維基礎',
        2: '算法入門',
        3: 'Python 基礎',
        4: '列表與進階',
        5: '測試與除錯',
        6: '專題應用'
      };
      return names[level] || '未知等級';
    }

    // 頁面加載
    window.onload = initSkillTree;
  </script>
</body>
</html>
```

---

## 第四步：角色卡面板 (`student_dashboard.html`)

```html
<!-- 簡化版本，完整代碼見下文交付 -->
<div class="character-card">
  <div class="header">
    <h2>李同 的修行卷軸</h2>
    <div class="level-badge">LV 3</div>
  </div>
  
  <div class="stats">
    <div class="stat">
      <span>總進度</span>
      <div class="progress-bar">
        <div class="progress-fill" style="width: 65%"></div>
      </div>
      <span>65%</span>
    </div>
    
    <div class="stat">
      <span>掌握技能</span>
      <span class="value">12/42</span>
    </div>
    
    <div class="stat">
      <span>經驗值</span>
      <span class="value">2850 / 5000 EXP</span>
    </div>
  </div>

  <div class="achievements">
    <h3>🏆 已獲徽章</h3>
    <div class="badge-grid">
      <div class="badge" title="除錯獵人">🐛</div>
      <div class="badge" title="知識分享者">📚</div>
    </div>
  </div>

  <div class="next-milestone">
    <h3>🎯 下一個里程碑</h3>
    <p>完成「列表遍歷」技能，即可解鎖「函數定義」</p>
  </div>
</div>
```

---

## 第五步：師徒配對儀表板 (`peer_teaching_hub.html`)

```
┌──────────────────────────────────────────┐
│ 🤝 師徒配對中心                          │
├──────────────────────────────────────────┤
│                                          │
│ 我是導師:                                │
│ ┌────────────────────────────────────┐  │
│ │ 小王 — 教「列表基礎」              │  │
│ │ 本月已教 3 次 ⭐⭐⭐⭐⭐ (5/5)  │  │
│ │ 下次約課: 週三 3:30                │  │
│ └────────────────────────────────────┘  │
│                                          │
│ 我想學:                                  │
│ ┌────────────────────────────────────┐  │
│ │ 函數定義 — 向小陳學習              │  │
│ │ 預約狀態: 待確認                   │  │
│ │ [確認預約] [換導師]                │  │
│ └────────────────────────────────────┘  │
│                                          │
│ 我可以教:                                │
│ ┌────────────────────────────────────┐  │
│ │ ✅ 除錯技巧   (精通)               │  │
│ │ ✅ if-else    (精通)               │  │
│ │ ✅ for 迴圈   (完成)               │  │
│ │ [我想開放這些技能給他人學習]       │  │
│ └────────────────────────────────────┘  │
│                                          │
└──────────────────────────────────────────┘
```

---

## 第六步：Supabase 初始化腳本

```sql
-- 創建所有表
CREATE TABLE skills (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  skill_code TEXT UNIQUE NOT NULL,
  skill_name TEXT NOT NULL,
  level INT NOT NULL,
  description TEXT,
  learning_resources TEXT[],
  difficulty INT,
  estimated_hours FLOAT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- 插入 DCH1 技能
INSERT INTO skills (skill_code, skill_name, level, description, difficulty, estimated_hours) VALUES
('思維1', '問題界定 (6何法)', 1, '學習用 6何法分析問題範疇', 1, 1.5),
('思維2', 'IPO 模型', 1, '掌握輸入-處理-輸出的設計思維', 2, 2),
('思維3', '問題拆解 (分解)', 1, '學會將大問題分拆為小子問題', 2, 2),
('思維4', '模式識別', 1, '從不同問題中發現共同模式', 3, 2.5),
('思維5', '抽象化概念', 1, '學會提取問題的本質，忽略細節', 3, 2),
('思維6', 'UI 設計基礎', 1, '設計易用的用戶界面', 2, 1.5),

('算法1', '偽代碼撰寫', 2, '用自然語言描述算法步驟', 2, 1.5),
('算法2', '流程圖繪製', 2, '用圖形表示程式流程', 2, 1.5),
('算法3', '變量與賦值', 2, '理解變量的概念與賦值操作', 1, 1),
('算法4', '數據類型', 2, '掌握 int, float, bool, str 的區別', 2, 1.5),
('算法5', 'if-else 條件', 2, '學會編寫條件分支', 2, 2),
('算法6', '陣列概念', 2, '理解陣列的索引與操作', 2, 2),
('算法7', '加總與平均', 2, '掌握基本的陣列運算', 1, 1),
('算法8', '線性檢索', 2, '學會在陣列中查找元素', 2, 1.5),
('算法9', '最大最小值', 2, '掌握比較算法', 1, 1),
('算法10', '排序檢查', 2, '檢查陣列是否已排序', 2, 1.5),

('Python1', '變量宣告 (Python)', 3, '在 Python 中聲明與使用變量', 1, 0.5),
('Python2', '數據類型轉換', 3, '使用 int(), float(), str() 轉換', 2, 1),
('Python3', '輸入輸出', 3, '使用 input() 與 print()', 1, 1),
('Python4', '運算符', 3, '掌握算術運算符 +, -, *, /, //', 2, 1),
('Python5', '關係運算', 3, '使用 ==, !=, >, <, >=, <=', 1, 0.5),
('Python6', 'if 語句 (Python)', 3, '在 Python 中編寫條件語句', 2, 1),
('Python7', '布爾邏輯 (and/or/not)', 3, '組合多個條件判斷', 2, 1),
('Python8', 'for 迴圈', 3, '使用 for 與 range() 重複執行', 2, 1.5),
('Python9', 'while 迴圈', 3, '使用 while 實現條件迴圈', 2, 1.5),
('Python10', '內置函數', 3, '使用 abs(), round(), len(), min(), max()', 2, 1.5),
('Python11', '數學與隨機庫', 3, '導入 math 與 random 模組', 2, 1);

-- 創建前置關係表並插入數據
CREATE TABLE skill_dependencies (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  skill_id BIGINT NOT NULL REFERENCES skills(id),
  prerequisite_id BIGINT NOT NULL REFERENCES skills(id),
  is_strict BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(skill_id, prerequisite_id)
);

-- 其他表略...
```

---

## 第七步：未來擴展路線圖

```
Phase 1: 核心系統（現在）
├─ ✅ Supabase 數據庫結構
├─ ✅ RPG 技能樹前端
└─ ✅ 進度追蹤與視覺化

Phase 2: 智能推薦（下月）
├─ AI 推薦下一個技能
├─ 個性化學習路徑
└─ 自動徽章頒發

Phase 3: 社交協作（第三月）
├─ Telegram Bot 推播
├─ GitHub 代碼同步
└─ 師徒配對自動化

Phase 4: 遊戲化深化（第四月）
├─ 積分交易系統
├─ 排行榜與頻道聊天
└─ 自定義角色卡

Phase 5: 數據分析（學期中）
├─ 學習效率報告
├─ 個人發展軌跡
└─ 班級進度熱圖
```

---

## 使用說明

### 七兄需做的事：

1. **創建 Supabase Project**
   - 進 https://supabase.com
   - 新建 Project
   - 複製 URL 與 API Key

2. **執行初始化 SQL**
   - 在 Supabase SQL Editor 貼上上述創建表腳本
   - 執行

3. **配置 HTML 文件**
   - 替換 `SUPABASE_URL` 與 `SUPABASE_KEY`
   - 部署到 GitHub Pages 或學校伺服器

4. **導入學生數據**
   - 用 CSV 批量導入學生與進度
   - 或由零手工設置

### 學生端：
- 每週登入檢視技能樹進度
- 點擊技能卡查看前置條件
- 記錄學習反思
- 預約師徒教學

---

## 完整代碼交付清單

零將製作以下文件：

```
/S5-ICT-Python-RPG/
├── supabase-schema.sql          (數據庫完整腳本)
├── skill-tree.html              (技能樹可視化)
├── student-dashboard.html       (角色卡面板)
├── peer-teaching-hub.html       (師徒配對中心)
├── admin-panel.html             (七兄管理後台)
├── config.js                    (Supabase 配置)
└── README.md                    (使用文檔)
```

🎮 *七兄欲即刻啟動，抑或先試驗一小部分？*
