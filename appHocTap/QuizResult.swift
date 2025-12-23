//
//  QuizResult.swift
//  appHocTap
//
//  Created by  User on 22.12.2025.
//

import Foundation

struct QuizReviewItem: Identifiable {
    let id: String
    let title: String
    let userChoice: String
    let correctChoice: String
    let isCorrect: Bool
}

struct QuizResult {
    let fixedTotal: Int // luôn = 20 theo yêu cầu
    let correctCount: Int
    let timeUsedSeconds: Int?
    let reviewItems: [QuizReviewItem]
}
import Foundation

// 1. Tạo một struct con để lưu chi tiết câu sai
struct ReviewItem: Codable, Identifiable {
    var id = UUID()
    var questionText: String    // Nội dung câu hỏi
    var userChoice: String      // Đáp án người dùng chọn (Sai)
    var correctChoice: String   // Đáp án đúng
}

// 2. Cập nhật struct chính
struct QuizResult: Identifiable, Codable {
    var id: UUID = UUID()
    var date: Date
    var score: Int
    var totalQuestions: Int
    
    // Thay đổi từ [String] thành [ReviewItem] để lưu chi tiết hơn
    var wrongAnswers: [ReviewItem]
}
