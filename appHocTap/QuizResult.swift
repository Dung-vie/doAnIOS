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
