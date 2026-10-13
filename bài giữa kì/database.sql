-- =====================================================================
-- CƠ SỞ DỮ LIỆU: Ứng dụng thi TOEIC Reading
-- Môn: Lập trình thiết bị di động
-- Mô tả: Phân tích và Xây dựng ứng dụng thi TOEIC Reading
-- =====================================================================

CREATE DATABASE IF NOT EXISTS toeic_reading_db
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;

USE toeic_reading_db;

-- =====================================================================
-- BẢNG 1: USERS — Lưu thông tin tài khoản người dùng
-- =====================================================================
CREATE TABLE IF NOT EXISTS users (
    user_id       VARCHAR(50)  NOT NULL,
    username      VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name     VARCHAR(150) NOT NULL,
    role          ENUM('admin', 'user') NOT NULL DEFAULT 'user',
    email         VARCHAR(150)          DEFAULT NULL,
    created_at    DATETIME              DEFAULT CURRENT_TIMESTAMP,
    updated_at    DATETIME              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dữ liệu mẫu
INSERT INTO users (user_id, username, password_hash, full_name, role) VALUES
('u001', 'admin',  MD5('admin123'), 'Administrator',  'admin'),
('u002', 'user',   MD5('user123'),  'Sinh viên Demo', 'user');


-- =====================================================================
-- BẢNG 2: EXAMS — Lưu thông tin đề thi
-- =====================================================================
CREATE TABLE IF NOT EXISTS exams (
    exam_id      INT          NOT NULL AUTO_INCREMENT,
    exam_name    VARCHAR(200) NOT NULL,
    description  TEXT                  DEFAULT NULL,
    duration_min INT          NOT NULL DEFAULT 75,
    created_by   VARCHAR(50)           DEFAULT NULL,
    created_at   DATETIME              DEFAULT CURRENT_TIMESTAMP,
    updated_at   DATETIME              DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (exam_id),
    FOREIGN KEY (created_by) REFERENCES users(user_id) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dữ liệu mẫu
INSERT INTO exams (exam_name, description, duration_min, created_by) VALUES
('ETS TOEIC Reading Test 10', 'Đề thi ETS TOEIC Reading - Test 10, gồm Part 5, 6, 7', 75, 'u001');


-- =====================================================================
-- BẢNG 3: QUESTIONS — Lưu câu hỏi của từng đề thi
-- =====================================================================
CREATE TABLE IF NOT EXISTS questions (
    question_id   INT  NOT NULL AUTO_INCREMENT,
    exam_id       INT  NOT NULL,
    question_no   INT  NOT NULL,
    part          TINYINT NOT NULL COMMENT '5=Part5, 6=Part6, 7=Part7',
    passage       TEXT          DEFAULT NULL COMMENT 'Đoạn văn ngữ cảnh (Part 6, 7)',
    question_text TEXT NOT NULL,
    opt_a         VARCHAR(500) NOT NULL,
    opt_b         VARCHAR(500) NOT NULL,
    opt_c         VARCHAR(500) NOT NULL,
    opt_d         VARCHAR(500) NOT NULL,
    correct_ans   TINYINT NOT NULL COMMENT '0=A, 1=B, 2=C, 3=D',
    explanation   TEXT          DEFAULT NULL,
    created_at    DATETIME      DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (question_id),
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON DELETE CASCADE,
    INDEX idx_exam_part (exam_id, part)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dữ liệu mẫu (Part 5 — một số câu tiêu biểu)
INSERT INTO questions (exam_id, question_no, part, question_text, opt_a, opt_b, opt_c, opt_d, correct_ans, explanation) VALUES
(1, 101, 5, 'Please contact the product distributor, not the retail store, if _______ need replacement parts.',
 'your', 'you', 'yourself', 'yours', 1,
 'Cần đại từ nhân xưng chủ ngữ "you" đứng trước động từ "need".'),

(1, 102, 5, 'AGU Group''s insurance rates have remained steady _______ the last three years.',
 'at', 'by', 'to', 'for', 3,
 'Giới từ "for" đi với khoảng thời gian.'),

(1, 103, 5, 'Sage Bistro''s menu features a _______ variety of seafood items than Almaner Pavilion''s.',
 'wide', 'widest', 'wider', 'widely', 2,
 'Có "than" → dùng so sánh hơn "wider".'),

(1, 104, 5, 'Frequent training enables our technicians to resolve most computer problems _______.',
 'swiftly', 'avoidably', 'doubtfully', 'rigidly', 0,
 '"Swiftly" (nhanh chóng) phù hợp ngữ cảnh.'),

(1, 105, 5, 'Most of the manufacturing sector has reported higher profits as a result of the trade _______.',
 'agreement', 'agreeing', 'agreeably', 'agrees', 0,
 'Danh từ ghép "trade agreement" (hiệp định thương mại).');


-- =====================================================================
-- BẢNG 4: RESULTS — Lưu kết quả mỗi lần thi của user
-- =====================================================================
CREATE TABLE IF NOT EXISTS results (
    result_id     INT         NOT NULL AUTO_INCREMENT,
    user_id       VARCHAR(50) NOT NULL,
    exam_id       INT         NOT NULL,
    score_toeic   INT         NOT NULL DEFAULT 0  COMMENT 'Điểm ước tính 100-495',
    correct_count INT         NOT NULL DEFAULT 0,
    wrong_count   INT         NOT NULL DEFAULT 0,
    skip_count    INT         NOT NULL DEFAULT 0,
    duration_sec  INT         NOT NULL DEFAULT 0  COMMENT 'Thời gian làm bài (giây)',
    submitted_at  DATETIME    DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (result_id),
    FOREIGN KEY (user_id)  REFERENCES users(user_id)  ON DELETE CASCADE,
    FOREIGN KEY (exam_id)  REFERENCES exams(exam_id)  ON DELETE CASCADE,
    INDEX idx_user_exam (user_id, exam_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dữ liệu mẫu
INSERT INTO results (user_id, exam_id, score_toeic, correct_count, wrong_count, skip_count, duration_sec) VALUES
('u002', 1, 425, 85, 12, 3, 4095);


-- =====================================================================
-- BẢNG 5: ANSWERS — Lưu đáp án từng câu của mỗi lần thi
-- =====================================================================
CREATE TABLE IF NOT EXISTS answers (
    answer_id    INT     NOT NULL AUTO_INCREMENT,
    result_id    INT     NOT NULL,
    question_id  INT     NOT NULL,
    selected_ans TINYINT          DEFAULT NULL COMMENT '0=A, 1=B, 2=C, 3=D, NULL=bỏ qua',
    is_correct   BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (answer_id),
    FOREIGN KEY (result_id)   REFERENCES results(result_id)     ON DELETE CASCADE,
    FOREIGN KEY (question_id) REFERENCES questions(question_id) ON DELETE CASCADE,
    INDEX idx_result (result_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Dữ liệu mẫu
INSERT INTO answers (result_id, question_id, selected_ans, is_correct) VALUES
(1, 1, 1, TRUE),   -- câu 101: chọn B (you) - đúng
(1, 2, 3, TRUE),   -- câu 102: chọn D (for) - đúng
(1, 3, 2, TRUE),   -- câu 103: chọn C (wider) - đúng
(1, 4, 0, TRUE),   -- câu 104: chọn A (swiftly) - đúng
(1, 5, 1, FALSE);  -- câu 105: chọn B (agreeing) - sai


-- =====================================================================
-- VIEWS — Truy vấn thường dùng
-- =====================================================================

-- View: Thống kê kết quả theo user
CREATE OR REPLACE VIEW vw_user_stats AS
SELECT
    u.user_id,
    u.full_name,
    COUNT(r.result_id)    AS total_attempts,
    MAX(r.score_toeic)    AS best_score,
    AVG(r.score_toeic)    AS avg_score,
    MAX(r.submitted_at)   AS last_attempt
FROM users u
LEFT JOIN results r ON u.user_id = r.user_id
WHERE u.role = 'user'
GROUP BY u.user_id, u.full_name;

-- View: Chi tiết đề thi
CREATE OR REPLACE VIEW vw_exam_detail AS
SELECT
    e.exam_id,
    e.exam_name,
    e.duration_min,
    COUNT(q.question_id)                           AS total_questions,
    SUM(q.part = 5)                                AS part5_count,
    SUM(q.part = 6)                                AS part6_count,
    SUM(q.part = 7)                                AS part7_count,
    u.full_name                                    AS created_by_name,
    e.created_at
FROM exams e
LEFT JOIN questions q ON e.exam_id = q.exam_id
LEFT JOIN users u     ON e.created_by = u.user_id
GROUP BY e.exam_id, e.exam_name, e.duration_min, u.full_name, e.created_at;


-- =====================================================================
-- MỐI QUAN HỆ TÓM TẮT:
--
--   USERS (1) ──────────────── (N) EXAMS
--             (admin tạo đề)
--
--   EXAMS (1) ──────────────── (N) QUESTIONS
--             (1 đề có nhiều câu)
--
--   USERS (1) ──────────────── (N) RESULTS
--             (1 user có nhiều lần thi)
--
--   EXAMS (1) ──────────────── (N) RESULTS
--             (1 đề có nhiều lượt thi)
--
--   RESULTS (1) ─────────────── (N) ANSWERS
--               (1 kết quả gồm nhiều đáp án)
--
--   QUESTIONS (1) ──────────── (N) ANSWERS
--               (1 câu hỏi có nhiều lần được trả lời)
-- =====================================================================
