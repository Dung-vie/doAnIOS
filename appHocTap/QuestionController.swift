//
//  QuestionController.swift
//  appHocTap
//
//  Created by User on 23.12.2025.
//

import Foundation

class QuestionController {
    
    static let shared = QuestionController()
    
    private init() {}
    
    // Lấy danh sách câu hỏi thuộc về một bài học cụ thể
    func fetchQuestions(forLessonId lessonId: String, completion: @escaping ([Question]) -> Void) {
        // Lấy tất cả câu hỏi về rồi lọc (hoặc query trực tiếp nếu cấu trúc Firebase cho phép)
        fetchQuestions { allQuestions in
            let filtered = allQuestions.filter { $0.lessonId == lessonId }
            completion(filtered)
        }
    }
    
    // Ham update cau hoi
    func updateQuestion(_ question: Question, completion: @escaping (Bool) -> Void) {
            // Dùng lại hàm addQuestion của Database (vì nó ghi đè theo ID)
            MyDatabase.shared.addQuestion(question) { error in
                completion(error == nil)
            }
        }
    
    // --- Lấy danh sách câu hỏi ---
        func fetchQuestions(completion: @escaping ([Question]) -> Void) {
            MyDatabase.shared.getQuestions { questions in
                completion(questions)
            }
        }
        
        // --- Xóa câu hỏi ---
        func deleteQuestion(id: String, completion: @escaping (Bool) -> Void) {
            MyDatabase.shared.deleteQuestion(id: id) { error in
                completion(error == nil)
            }
        }
    
    // Hàm xử lý logic thêm câu hỏi
    func addQuestion(content: String,
                     answerA: String,
                     answerB: String,
                     answerC: String,
                     answerD: String,
                     correctAnswerIndex: Int,
                     lessonId: String,
                     completion: @escaping (Bool, String?) -> Void) {
        
        // 1. Tạo ID mới cho câu hỏi
        let newId = UUID().uuidString
        
        // 2. Tạo danh sách các đối tượng Answer
        // Lưu ý: Mỗi Answer cũng tự tạo ID bên trong init của nó
        let answers = [
            Answer(content: answerA),
            Answer(content: answerB),
            Answer(content: answerC),
            Answer(content: answerD)
        ]
        
        // 3. Tạo đối tượng Question
        let newQuestion = Question(
            id: newId,
            content: content,
            answers: answers,
            correctAnswerIndex: correctAnswerIndex,
            lessonId: lessonId
        )
        
        // 4. Gọi Database để lưu
        MyDatabase.shared.addQuestion(newQuestion) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
}
