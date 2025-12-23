//
//  Question.swift
//  appHocTap
//
//  Created by User on 16.12.2025.
//

import Foundation

struct Answer: Identifiable, Codable {
    var id: String
    var content: String
    
    // Init mặc định
    init(id: String = UUID().uuidString, content: String) {
        self.id = id
        self.content = content
    }
    
    // Hàm chuyển đổi sang Dictionary để lưu Firebase
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "content": content
        ]
    }
}

struct Question: Identifiable, Codable {
    let id: String
    var content: String
    var answers: [Answer]
    var correctAnswerIndex: Int
    var lessonId: String
    
    // --- SỬA LẠI INIT CHO ĐÚNG ---
    init(id: String = UUID().uuidString,
         content: String,
         answers: [Answer],
         correctAnswerIndex: Int,
         lessonId: String) { // Thêm lessonId vào đây
        
        self.id = id
        self.content = content
        self.answers = answers
        self.correctAnswerIndex = correctAnswerIndex
        self.lessonId = lessonId
    }
    
    // Hàm chuyển đổi sang Dictionary để lưu Firebase
    func toDictionary() -> [String: Any] {
        // Convert mảng Answer sang mảng Dictionary con
        let answersDict = answers.map { $0.toDictionary() }
        
        return [
            "id": id,
            "content": content,
            "answers": answersDict,
            "correctAnswerIndex": correctAnswerIndex,
            "lessonId": lessonId
        ]
    }
}
