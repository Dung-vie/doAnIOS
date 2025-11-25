//
//  QuestionData.swift
//  hocTap
//
//  Created by  User on 25.11.2025.
//

import Foundation

struct Question {
    let id: Int
    let question: String
    let answers: [String]
    let correct: Int
}

// MARK: - Khối 1 Toán
let grade1Math: [Question] = [
    Question(id: 1, question: "1 + 1 = ?", answers: ["1", "2", "3", "4"], correct: 1),
    Question(id: 2, question: "2 + 3 = ?", answers: ["4", "5", "6", "7"], correct: 1),
    Question(id: 3, question: "5 - 2 = ?", answers: ["2", "3", "4", "5"], correct: 1),
    Question(id: 4, question: "3 + 4 = ?", answers: ["6", "7", "8", "9"], correct: 1),
    Question(id: 5, question: "10 - 6 = ?", answers: ["2", "3", "4", "5"], correct: 2),
    Question(id: 6, question: "2 x 3 = ?", answers: ["5", "6", "7", "8"], correct: 1),
    Question(id: 7, question: "9 - 5 = ?", answers: ["3", "4", "5", "6"], correct: 1),
    Question(id: 8, question: "4 + 4 = ?", answers: ["6", "7", "8", "9"], correct: 2),
    Question(id: 9, question: "12 - 7 = ?", answers: ["4", "5", "6", "7"], correct: 1),
    Question(id: 10, question: "5 + 5 = ?", answers: ["9", "10", "11", "12"], correct: 1),
    Question(id: 11, question: "8 - 3 = ?", answers: ["4", "5", "6", "7"], correct: 1),
    Question(id: 12, question: "6 + 2 = ?", answers: ["7", "8", "9", "10"], correct: 1),
    Question(id: 13, question: "7 - 4 = ?", answers: ["2", "3", "4", "5"], correct: 1),
    Question(id: 14, question: "3 x 2 = ?", answers: ["5", "6", "7", "8"], correct: 1),
    Question(id: 15, question: "10 - 8 = ?", answers: ["1", "2", "3", "4"], correct: 1),
    Question(id: 16, question: "2 + 7 = ?", answers: ["8", "9", "10", "11"], correct: 1),
    Question(id: 17, question: "9 - 2 = ?", answers: ["6", "7", "8", "9"], correct: 1),
    Question(id: 18, question: "4 + 5 = ?", answers: ["8", "9", "10", "11"], correct: 1),
    Question(id: 19, question: "6 - 1 = ?", answers: ["4", "5", "6", "7"], correct: 1),
    Question(id: 20, question: "3 + 6 = ?", answers: ["8", "9", "10", "11"], correct: 1)
]

// MARK: - Khối 1 Tiếng Việt
let grade1Vietnamese: [Question] = [
    Question(id: 1, question: "Chữ cái đầu tiên trong bảng chữ cái là gì?", answers: ["A", "B", "C", "D"], correct: 0),
    Question(id: 2, question: "Từ 'mèo' thuộc loại từ nào?", answers: ["Danh từ", "Động từ", "Tính từ", "Trạng từ"], correct: 0),
    Question(id: 3, question: "Ghép từ đúng: con ____", answers: ["mèo", "chó", "cá", "chim"], correct: 0),
    Question(id: 4, question: "Từ 'chạy' thuộc loại từ nào?", answers: ["Danh từ", "Động từ", "Tính từ", "Trạng từ"], correct: 1),
    Question(id: 5, question: "Từ 'đẹp' thuộc loại từ nào?", answers: ["Danh từ", "Động từ", "Tính từ", "Trạng từ"], correct: 2),
    Question(id: 6, question: "Từ 'nhanh' thuộc loại từ nào?", answers: ["Danh từ", "Động từ", "Tính từ", "Trạng từ"], correct: 3),
    Question(id: 7, question: "Từ 'bút' thuộc loại từ nào?", answers: ["Danh từ", "Động từ", "Tính từ", "Trạng từ"], correct: 0),
    Question(id: 8, question: "Từ 'ăn' thuộc loại từ nào?", answers: ["Danh từ", "Động từ", "Tính từ", "Trạng từ"], correct: 1),
    Question(id: 9, question: "Từ 'cao' thuộc loại từ nào?", answers: ["Danh từ", "Động từ", "Tính từ", "Trạng từ"], correct: 2),
    Question(id: 10, question: "Từ 'chậm' thuộc loại từ nào?", answers: ["Danh từ", "Động từ", "Tính từ", "Trạng từ"], correct: 3),
    Question(id: 11, question: "Ghép từ đúng: quả ____", answers: ["cam", "mèo", "chạy", "đẹp"], correct: 0),
    Question(id: 12, question: "Ghép từ đúng: con ____", answers: ["chó", "đẹp", "cao", "ăn"], correct: 0),
    Question(id: 13, question: "Từ 'trường học' thuộc loại từ nào?", answers: ["Danh từ", "Động từ", "Tính từ", "Trạng từ"], correct: 0),
    Question(id: 14, question: "Từ 'ngủ' thuộc loại từ nào?", answers: ["Danh từ", "Động từ", "Tính từ", "Trạng từ"], correct: 1),
    Question(id: 15, question: "Từ 'xinh' thuộc loại từ nào?", answers: ["Danh từ", "Động từ", "Tính từ", "Trạng từ"], correct: 2),
    Question(id: 16, question: "Từ 'nhanh chóng' thuộc loại từ nào?", answers: ["Danh từ", "Động từ", "Tính từ", "Trạng từ"], correct: 3),
    Question(id: 17, question: "Ghép từ đúng: cây ____", answers: ["bút", "chạy", "cao", "đẹp"], correct: 0),
    Question(id: 18, question: "Ghép từ đúng: con ____", answers: ["chim", "ăn", "xinh", "chậm"], correct: 0),
    Question(id: 19, question: "Từ 'học' thuộc loại từ nào?", answers: ["Danh từ", "Động từ", "Tính từ", "Trạng từ"], correct: 1),
    Question(id: 20, question: "Từ 'xấu' thuộc loại từ nào?", answers: ["Danh từ", "Động từ", "Tính từ", "Trạng từ"], correct: 2)
]

// MARK: - Khối 1 English
let grade1English: [Question] = [
    Question(id: 1, question: "What is the color of the sky?", answers: ["Red", "Blue", "Green", "Yellow"], correct: 1),
    Question(id: 2, question: "How many legs does a cat have?", answers: ["2", "3", "4", "5"], correct: 2),
    Question(id: 3, question: "What is 'apple' in Vietnamese?", answers: ["Cam", "Táo", "Xoài", "Dưa"], correct: 1),
    Question(id: 4, question: "What is 2 + 2?", answers: ["3", "4", "5", "6"], correct: 1),
    Question(id: 5, question: "What is the opposite of 'big'?", answers: ["Small", "Tall", "Short", "Thin"], correct: 0),
    Question(id: 6, question: "What is the color of grass?", answers: ["Blue", "Green", "Yellow", "Red"], correct: 1),
    Question(id: 7, question: "How many days in a week?", answers: ["5", "6", "7", "8"], correct: 2),
    Question(id: 8, question: "What is 'dog' in Vietnamese?", answers: ["Mèo", "Chó", "Cá", "Gà"], correct: 1),
]

// MARK: - Dictionary tổng hợp
let grade1Questions: [String: [Question]] = [
    "Math": grade1Math,
    "Vietnamese": grade1Vietnamese,
    "English": grade1English
]
