import Foundation

// 1. Struct chi tiết câu sai
struct ReviewItem: Codable, Identifiable {
    var id = UUID()
    var questionText: String
    var userChoice: String
    var correctChoice: String
    
    // Hàm chuyển đổi sang Dictionary để gửi lên Firebase
    func toDict() -> [String: Any] {
        return [
            "questionText": questionText,
            "userChoice": userChoice,
            "correctChoice": correctChoice
        ]
    }
}

// 2. Struct Lịch sử làm bài (Hứng từ Firebase về)
struct QuizHistoryItem: Identifiable {
    var id: String // ID của dòng lịch sử trên Firebase
    var score: Int
    var totalQuestions: Int
    var dateString: String
    var wrongAnswers: [ReviewItem]
    
    // Hàm khởi tạo từ dữ liệu Firebase (Dictionary)
    init(id: String, data: [String: Any]) {
        self.id = id
        self.score = data["score"] as? Int ?? 0
        self.totalQuestions = data["totalQuestions"] as? Int ?? 0
        self.dateString = data["dateString"] as? String ?? ""
        
        // Xử lý mảng câu sai (Phức tạp nhất: Phải parse từ Array<Dict> -> Array<Object>)
        if let rawWrongList = data["wrongAnswers"] as? [[String: Any]] {
            self.wrongAnswers = rawWrongList.map { dict in
                ReviewItem(
                    questionText: dict["questionText"] as? String ?? "",
                    userChoice: dict["userChoice"] as? String ?? "",
                    correctChoice: dict["correctChoice"] as? String ?? ""
                )
            }
        } else {
            self.wrongAnswers = []
        }
    }
}