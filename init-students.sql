-- 初始化 5 名學生的進度記錄
-- 執行此腳本於 Supabase SQL Editor

INSERT INTO student_progress (student_id, student_name, student_title, skill_id, status, progress)
SELECT 
  s.student_id,
  s.student_name,
  '初入山門',
  sk.id,
  CASE 
    WHEN sk.level = 1 THEN 'available'  -- 第一層解鎖
    ELSE 'locked'                       -- 其他層鎖定
  END,
  CASE 
    WHEN sk.level = 1 THEN 0
    ELSE 0
  END
FROM (
  SELECT '李同' as student_id, '李同' as student_name
  UNION ALL SELECT '王同', '王同'
  UNION ALL SELECT '陳同', '陳同'
  UNION ALL SELECT '黃同', '黃同'
  UNION ALL SELECT '綠同', '綠同'
) s
CROSS JOIN skills sk
ON CONFLICT (student_id, skill_id) DO NOTHING;

-- 驗證初始化
SELECT 
  student_id,
  COUNT(*) as total_skills,
  SUM(CASE WHEN status = 'available' THEN 1 ELSE 0 END) as available,
  SUM(CASE WHEN status = 'locked' THEN 1 ELSE 0 END) as locked
FROM student_progress
GROUP BY student_id
ORDER BY student_id;
