-- S5 Python 修行之路 — 古風 RPG 技能樹
-- Supabase 初始化完整腳本

-- ============================================
-- 1. 技能表 (skills)
-- ============================================
CREATE TABLE skills (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  skill_code TEXT UNIQUE NOT NULL,
  skill_name TEXT NOT NULL,
  skill_name_ancient TEXT,           -- 古風名稱
  level INT NOT NULL,
  description TEXT,
  description_ancient TEXT,          -- 古風說明
  learning_resources TEXT[],
  difficulty INT,
  estimated_hours FLOAT,
  icon_emoji TEXT,                   -- 技能圖示
  created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- 2. 技能前置關係表 (skill_dependencies)
-- ============================================
CREATE TABLE skill_dependencies (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  skill_id BIGINT NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  prerequisite_id BIGINT NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  is_strict BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(skill_id, prerequisite_id)
);

-- ============================================
-- 3. 學生進度表 (student_progress)
-- ============================================
CREATE TABLE student_progress (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  student_id TEXT NOT NULL,
  student_name TEXT NOT NULL,
  student_title TEXT DEFAULT '初入山門',  -- 身份/稱號
  skill_id BIGINT NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  status TEXT DEFAULT 'locked',    -- locked/available/in_progress/completed/mastered
  progress INT DEFAULT 0,
  attempts INT DEFAULT 0,
  quiz_score INT,
  completed_at TIMESTAMP,
  last_updated_at TIMESTAMP DEFAULT NOW(),
  notes TEXT,
  UNIQUE(student_id, skill_id)
);

-- ============================================
-- 4. 師徒配對表 (peer_teachers)
-- ============================================
CREATE TABLE peer_teachers (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  teacher_id TEXT NOT NULL,
  teacher_name TEXT NOT NULL,
  student_id TEXT NOT NULL,
  student_name TEXT NOT NULL,
  skill_id BIGINT NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  month INT,
  session_count INT DEFAULT 0,
  feedback_score INT,
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- 5. 徽章系統表 (achievements)
-- ============================================
CREATE TABLE achievements (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  achievement_code TEXT UNIQUE,
  achievement_name TEXT NOT NULL,
  achievement_name_ancient TEXT,
  description TEXT,
  icon_emoji TEXT,
  criteria TEXT,                     -- JSON 格式的達成條件
  reward_points INT DEFAULT 10,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE student_achievements (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  student_id TEXT NOT NULL,
  student_name TEXT NOT NULL,
  achievement_id BIGINT NOT NULL REFERENCES achievements(id) ON DELETE CASCADE,
  earned_at TIMESTAMP DEFAULT NOW(),
  UNIQUE(student_id, achievement_id)
);

-- ============================================
-- 6. 學習日誌表 (learning_logs)
-- ============================================
CREATE TABLE learning_logs (
  id BIGINT PRIMARY KEY GENERATED ALWAYS AS IDENTITY,
  student_id TEXT NOT NULL,
  student_name TEXT NOT NULL,
  skill_id BIGINT NOT NULL REFERENCES skills(id) ON DELETE CASCADE,
  action TEXT,                      -- started/watched/practiced/passed_quiz/asked_help/reflection
  duration_minutes INT,
  reflection TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- ============================================
-- 7. 插入技能數據 — 第一層：思維基礎
-- ============================================
INSERT INTO skills (skill_code, skill_name, skill_name_ancient, level, description, description_ancient, difficulty, estimated_hours, icon_emoji) VALUES
('思維1', '問題界定', '心應手畔·辨事理', 1, '用六何法分析問題範疇', '習六何之問法，明問題之邊界', 1, 1.5, '🎯'),
('思維2', 'IPO 模型', '三才構通·縱橫紀', 2, '掌握輸入-處理-輸出設計思維', '領悟三才之理：納外物，運心法，化玉成', 2, 2, '⚙️'),
('思維3', '問題拆解', '分天地·破難局', 1, '將大問題分拆為小子問題', '以分治之道，破繁難為簡易', 2, 2, '🔱'),
('思維4', '模式識別', '識萬物·通古今', 3, '從不同問題中發現共同模式', '觀百事而悟其理，得一以應萬般', 3, 2.5, '🔍'),
('思維5', '抽象化概念', '棄塵埃·留精髓', 2, '提取問題本質，忽略細節', '去其蕪蔓，存其菁華，以簡御繁', 3, 2, '☁️'),
('思維6', 'UI 設計基礎', '界面妙·用者喜', 2, '設計易用的用戶界面', '以用者心為心，使三尺屏幕成樂園', 2, 1.5, '✨');

-- ============================================
-- 8. 插入技能數據 — 第二層：算法入門
-- ============================================
INSERT INTO skills (skill_code, skill_name, skill_name_ancient, level, description, description_ancient, difficulty, estimated_hours, icon_emoji) VALUES
('算法1', '偽代碼撰寫', '文言描·步步明', 2, '用自然語言描述算法步驟', '以筆墨之辭記天下之法，使人一覽即知', 2, 1.5, '📝'),
('算法2', '流程圖繪製', '圖形載·心意展', 2, '用圖形表示程式流程', '圖之妙，勝千言；一紙見通、分支、迴環之妙', 2, 1.5, '🗺️'),
('算法3', '變量與賦值', '盒內藏·標名記', 1, '理解變量概念與賦值操作', '如書簽置卷頁，標號而可索回', 1, 1, '📦'),
('算法4', '數據類型', '四行五·水火木', 2, '掌握 int, float, bool, str 的區別', '數有數之族，字有字之源；各得其類，方能妙用', 2, 1.5, '🎨'),
('算法5', '分支判斷', '路岔分·擇其一', 2, '學會編寫條件分支（if-else）', '若此則彼，若非則他；以條件為舟，撐過決策江', 2, 2, '🌳'),
('算法6', '陣列之法', '列行排·序可尋', 2, '理解陣列的索引與操作', '如軍陣之行列，按次第而取，無序則亂', 2, 2, '📊'),
('算法7', '加總與平均', '聚化一·分成多', 1, '掌握基本的陣列運算', '積沙成塔，眾星列宿，終歸一數', 1, 1, '🔢'),
('算法8', '線性查尋', '逐格掃·尋芳蹤', 2, '學會在陣列中查找元素', '如翻書頁逐行讀，待尋到心中之物', 2, 1.5, '🔎'),
('算法9', '極值探幽', '擎高舉·伏低俯', 1, '掌握最大最小值比較算法', '摟拔其尤，踐踏其弱，得峰谷之位', 1, 1, '⛰️'),
('算法10', '序列檢察', '排必順·乱立知', 2, '檢查陣列是否已排序', '以相鄰比對，知陣是否成列', 2, 1.5, '✅');

-- ============================================
-- 9. 插入技能數據 — 第三層：Python 基礎
-- ============================================
INSERT INTO skills (skill_code, skill_name, skill_name_ancient, level, description, description_ancient, difficulty, estimated_hours, icon_emoji) VALUES
('Python1', '蛇符變量', '蛇文·名標記', 3, '在 Python 中聲明與使用變量', '蛇語之中，以符號為名，盛物於無形之器', 1, 0.5, '🐍'),
('Python2', '鑄型之術', '爐火·質變通', 3, '使用 int(), float(), str() 轉換', '如煉丹之爐，金可化銀，銀可化銅', 2, 1, '🔄'),
('Python3', '納言與出言', '口納·耳聽', 3, '使用 input() 與 print()', '眼收四方聲，口發八方言', 1, 1, '💬'),
('Python4', '四則運數', '加減乘除·算盤珠', 3, '掌握算術運算符 +, -, *, /, //', '古之算盤珠動珠落，今之符號算數生', 2, 1, '🧮'),
('Python5', '較量之道', '孰多孰少·比大小', 1, '使用 ==, !=, >, <, >=, <=', '天下之物，大小先後，皆可比對', 1, 0.5, '⚖️'),
('Python6', '蛇文·分支', '路分三·擇其善', 3, '在 Python 中編寫條件語句', '蛇之道亦分岔，以是非判途徑', 2, 1, '🔀'),
('Python7', '邏輯玄機', '且與或·真與假', 2, '組合多個條件判斷 (and/or/not)', '諸般條件，縱橫交織，始得真意', 2, 1, '🎭'),
('Python8', '循環迴圈', '環環·相為貫', 3, '使用 for 與 range() 重複執行', '如琵琶弦環環相扣，每環一事，周而復始', 2, 1.5, '🔄'),
('Python9', '條件迴圈', '待時至·方息肩', 3, '使用 while 實現條件迴圈', '監門客待客至方入，條件成而迴圈止', 2, 1.5, '⏳'),
('Python10', '內秘函術', '函藏寶·一呼百應', 2, '使用 abs(), round(), len(), min(), max()', '如仙人秘籍，一招一式，妙用無窮', 2, 1.5, '📖'),
('Python11', '數理秘笈', '數之理·隨機機', 2, '導入 math 與 random 模組', '天地間數理玄機，月盈虧、兆從無端', 2, 1, '📚');

-- ============================================
-- 10. 插入技能數據 — 第四層：列表與進階
-- ============================================
INSERT INTO skills (skill_code, skill_name, skill_name_ancient, level, description, description_ancient, difficulty, estimated_hours, icon_emoji) VALUES
('進階1', '列表初識', '千般物·一籠收', 4, '列表基礎概念與操作', '如棋盤置子，子子相連，一籠而收', 2, 2, '📦'),
('進階2', '索引之鑰', '位置號·定其所', 4, '理解列表索引的含義與用法', '位置有序，以數相呼，百寶箱開啟在指尖', 2, 1.5, '🔑'),
('進階3', '遍歷萬物', '逐一歷·無漏網', 4, '用循環遍歷列表的每一個元素', '如巡甲兵隊，逐人點名，無一遺漏', 2, 2, '🚶'),
('進階4', '列表妙法', '增刪改·靈活應', 4, '掌握 append, insert, remove, pop 等方法', '如刀斧加工，削增修補，列表面目為之一新', 3, 2, '✂️'),
('進階5', '字符織錦', '符號連·成文章', 3, '理解字符串的本質與操作', '字以連珠，成文成篇，蕴籍無窮意', 2, 1.5, '📜'),
('進階6', '切片截旨', '片段取·精髓得', 4, '使用字符串切片提取所需部分', '如截錦緞一角，得其花紋，棄其餘繒', 2, 1.5, '✁️'),
('進階7', '函數建樹', '招式名·體系成', 3, '理解函數的定義與調用', '如創派立訣，一招一式，自成章法', 3, 2, '🌳'),
('進階8', '參數傳授', '訣中言·相互通', 4, '掌握函數的參數與返回值', '如師傳弟，言語為憑，回音為證', 2, 1.5, '📞'),
('進階9', '綜合運手', '百般技·化為一', 4, '綜合應用所學技能解決問題', '集思廣益，千般絕學融為一體', 3, 3, '⚔️');

-- ============================================
-- 11. 插入技能數據 — 第五層：測試與除錯
-- ============================================
INSERT INTO skills (skill_code, skill_name, skill_name_ancient, level, description, description_ancient, difficulty, estimated_hours, icon_emoji) VALUES
('測試1', '試題之道', '題出·驗其真', 5, '理解測試的目的與方法', '以題試法，方知成敗；此乃修行必經路', 2, 1.5, '🧪'),
('測試2', '文法察錯', '筆誤尋·莫放過', 4, '檢查與排除語法錯誤', '文法既謬，直譯器拒門外；不可不慎', 1, 1.5, '⚠️'),
('測試3', '運行之難', '程起·突然斃', 4, '理解並排除運行時錯誤', '如刀出鞘時斷，或馬疾奔時蹶；須尋根源', 2, 1.5, '💥'),
('測試4', '邏輯之謎', '計算對·答案謬', 3, '發現並排除邏輯錯誤', '程式雖跑，答案卻異；此為邏輯之患', 2, 2, '🤔'),
('測試5', '試數之策', '邊界測·異常知', 4, '設計有代表性的測試數據', '邊界之數、無效之數，皆需試之', 3, 2, '📊'),
('測試6', '空運之法', '手算行·步步追蹤', 4, '用空運與追蹤表除錯', '不運不知，一紙追蹤，變量盡露', 2, 1.5, '📈'),
('測試7', '除錯秘訣', '尋根源·知改處', 3, '掌握系統的除錯方法與技巧', '如醫者診脈，尋病之根，方能妙手回春', 3, 2, '🔍');

-- ============================================
-- 12. 插入技能數據 — 第六層：專題應用
-- ============================================
INSERT INTO skills (skill_code, skill_name, skill_name_ancient, level, description, description_ancient, difficulty, estimated_hours, icon_emoji) VALUES
('專題1', '網絡偵探', '蛛絲網·信息採', 6, '學會基本的網頁爬蟲技術', '如蜘蛛巧織網，吸取網上信息為己用', 3, 3, '🕷️'),
('專題2', '卷軸之術', '讀寫檔·永遠存', 4, '掌握文件的讀寫操作', '如手抄經卷，永久留存，世代相傳', 2, 2, '📄'),
('專題3', '畫卷之美', '數化圖·千般狀', 5, '使用圖表庫實現資料視覺化', '數字無形，圖表有象；一圖勝千言', 3, 3, '📈'),
('專題4', '應用鑄造', '綜合力·成一器', 5, '設計並實現微型應用程式', '融百般技，鑄實用之物，成器成道', 4, 4, '🛠️'),
('專題5', '修行圓滿', '道可成·功可就', 6, '完成期末綜合專題', '十月修行，一朝圓滿；從此踏上新征途', 5, 5, '🏆');

-- ============================================
-- 13. 插入前置依賴關係
-- ============================================
-- 第二層依賴於第一層
INSERT INTO skill_dependencies (skill_id, prerequisite_id, is_strict) SELECT s1.id, s2.id, TRUE FROM skills s1, skills s2 WHERE s1.skill_code = '算法1' AND s2.skill_code = '思維6';
INSERT INTO skill_dependencies (skill_id, prerequisite_id, is_strict) SELECT s1.id, s2.id, TRUE FROM skills s1, skills s2 WHERE s1.skill_code = '算法2' AND s2.skill_code = '思維6';
INSERT INTO skill_dependencies (skill_id, prerequisite_id, is_strict) SELECT s1.id, s2.id, TRUE FROM skills s1, skills s2 WHERE s1.skill_code = '算法3' AND s2.skill_code = '思維1';
INSERT INTO skill_dependencies (skill_id, prerequisite_id, is_strict) SELECT s1.id, s2.id, TRUE FROM skills s1, skills s2 WHERE s1.skill_code = '算法5' AND s2.skill_code = '算法4';
INSERT INTO skill_dependencies (skill_id, prerequisite_id, is_strict) SELECT s1.id, s2.id, TRUE FROM skills s1, skills s2 WHERE s1.skill_code = '算法6' AND s2.skill_code = '算法4';

-- 第三層 Python 依賴於第二層算法
INSERT INTO skill_dependencies (skill_id, prerequisite_id, is_strict) SELECT s1.id, s2.id, TRUE FROM skills s1, skills s2 WHERE s1.skill_code = 'Python1' AND s2.skill_code = '算法3';
INSERT INTO skill_dependencies (skill_id, prerequisite_id, is_strict) SELECT s1.id, s2.id, TRUE FROM skills s1, skills s2 WHERE s1.skill_code = 'Python6' AND s2.skill_code = '算法5';
INSERT INTO skill_dependencies (skill_id, prerequisite_id, is_strict) SELECT s1.id, s2.id, TRUE FROM skills s1, skills s2 WHERE s1.skill_code = 'Python8' AND s2.skill_code = 'Python3';
INSERT INTO skill_dependencies (skill_id, prerequisite_id, is_strict) SELECT s1.id, s2.id, TRUE FROM skills s1, skills s2 WHERE s1.skill_code = 'Python9' AND s2.skill_code = 'Python8';

-- 進階 4 層依賴於 Python
INSERT INTO skill_dependencies (skill_id, prerequisite_id, is_strict) SELECT s1.id, s2.id, TRUE FROM skills s1, skills s2 WHERE s1.skill_code = '進階1' AND s2.skill_code = 'Python8';
INSERT INTO skill_dependencies (skill_id, prerequisite_id, is_strict) SELECT s1.id, s2.id, TRUE FROM skills s1, skills s2 WHERE s1.skill_code = '進階5' AND s2.skill_code = 'Python3';
INSERT INTO skill_dependencies (skill_id, prerequisite_id, is_strict) SELECT s1.id, s2.id, TRUE FROM skills s1, skills s2 WHERE s1.skill_code = '進階7' AND s2.skill_code = 'Python10';

-- ============================================
-- 14. 插入徽章數據
-- ============================================
INSERT INTO achievements (achievement_code, achievement_name, achievement_name_ancient, description, icon_emoji, reward_points) VALUES
('bug_hunter', '除錯獵人', '蟲獵者·破疑陣', '成功除錯 5 次', '🐛', 20),
('knowledge_sharer', '知識分享者', '傳道人·授業成', '教導同學 3 門技能', '📚', 25),
('algorithm_master', '算法大師', '法家通·道貫通', '掌握所有算法技能', '⚙️', 50),
('python_expert', 'Python 專家', '蛇文宗·技藝高', '掌握所有 Python 技能', '🐍', 50),
('all_rounder', '全能修行者', '百藝通·樣樣精', '掌握超過 30 個技能', '⭐', 100),
('first_master', '首位精通者', '先馳騁·領風騷', '首個技能達到精通', '🏆', 75),
('perseverance', '堅毅之心', '百般試·不言敗', '在單一技能嘗試超過 10 次', '💪', 30);

-- ============================================
-- 15. 創建視圖：學生完整進度
-- ============================================
CREATE VIEW student_profile_view AS
SELECT 
  sp.student_id,
  sp.student_name,
  sp.student_title,
  COUNT(DISTINCT CASE WHEN sp.status = 'completed' THEN sp.skill_id END) as completed_skills,
  COUNT(DISTINCT CASE WHEN sp.status = 'mastered' THEN sp.skill_id END) as mastered_skills,
  COUNT(DISTINCT sp.skill_id) as total_tracked_skills,
  ROUND(100.0 * SUM(sp.progress) / COUNT(*), 2) as overall_progress,
  COUNT(DISTINCT sa.achievement_id) as achievement_count,
  MAX(sp.last_updated_at) as last_activity
FROM student_progress sp
LEFT JOIN student_achievements sa ON sp.student_id = sa.student_id
GROUP BY sp.student_id, sp.student_name, sp.student_title;

-- ============================================
-- 16. 啟用 RLS (Row Level Security) 用於安全性
-- ============================================
ALTER TABLE skills ENABLE ROW LEVEL SECURITY;
ALTER TABLE student_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE peer_teachers ENABLE ROW LEVEL SECURITY;
ALTER TABLE achievements ENABLE ROW LEVEL SECURITY;
ALTER TABLE learning_logs ENABLE ROW LEVEL SECURITY;

-- 創建公開策略
CREATE POLICY "skills_public_read" ON skills
  FOR SELECT USING (true);

CREATE POLICY "student_progress_user_read" ON student_progress
  FOR SELECT USING (student_id = current_user_id() OR true);

-- ============================================
-- 完成初始化
-- ============================================
-- 所有表已創建，數據已導入
-- 下一步：七兄配置 Supabase API 密鑰與前端代碼
