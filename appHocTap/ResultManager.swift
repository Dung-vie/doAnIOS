import Foundation

class ResultManager: ObservableObject {
    // Singleton: Giúp truy cập biến này ở bất cứ đâu
    static let shared = ResultManager()
    
    // Danh sách lịch sử làm bài
    @Published var history: [QuizResult] = []
    
    // Khóa để lưu vào bộ nhớ máy (giống như mật khẩu để mở két sắt lấy dữ liệu)
    private let storageKey = "USER_QUIZ_HISTORY"
    
    init() {
        // Khi app mở lên thì tự động tải dữ liệu cũ lên
        loadResults()
    }
    
// --- CẬP NHẬT HÀM LƯU: Nhận vào [ReviewItem] ---
    func saveNewResult(score: Int, totalQuestions: Int, wrongAnswers: [ReviewItem]) {
        let newResult = QuizResult(
            date: Date(),
            score: score,
            totalQuestions: totalQuestions,
            wrongAnswers: wrongAnswers
        )
        
        history.insert(newResult, at: 0)
        saveToLocalStorage()
        print("✅ Đã lưu kết quả mới!")
    }
    
    // --- HÀM PHỤ TRỢ: Ghi dữ liệu xuống ổ cứng ---
    private func saveToLocalStorage() {
        if let encodedData = try? JSONEncoder().encode(history) {
            UserDefaults.standard.set(encodedData, forKey: storageKey)
            print("✅ Đã lưu kết quả thành công!")
        }
    }
    
    // --- HÀM PHỤ TRỢ: Đọc dữ liệu từ ổ cứng lên ---
    func loadResults() {
        if let savedData = UserDefaults.standard.data(forKey: storageKey),
           let decodedList = try? JSONDecoder().decode([QuizResult].self, from: savedData) {
            self.history = decodedList
        }
    }

    
}