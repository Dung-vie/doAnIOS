//
//  Question.swift
//  appHocTap
//
//  Created by  User on 16.12.2025.
//

import Foundation

struct Question: Identifiable, Codable {
    let id: UUID
    var content: String
    var answers: [Answer]
    var correctAnswerIndex: Int
    
    init(id: UUID = UUID(), content: String, answers: [Answer], correctAnswerIndex: Int) {
        self.id = id
        self.content = content
        self.answers = answers
        self.correctAnswerIndex = correctAnswerIndex
    }
}

struct Answer: Identifiable, Codable {
    let id: UUID
    var content: String
    var isSelected: Bool = false
    
    init(id: UUID = UUID(), content: String) {
        self.id = id
        self.content = content
    }
}
