import Foundation

final class QuizController: ObservableObject {

    // Config
    private let fixedTotal = 20

    /// bankKey = subjectKey dạng "toan_1", "van_1", "anh_1"
    private let bankKey: String

    /// lessonId = "lesson1", "lesson2", ... hoặc "practice"
    /// - Nếu nil / "practice" => coi như làm đề tổng hợp
    private let lessonId: String?

    private let isUnlimited: Bool
    private let durationSeconds: Int?

    // State
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil

    @Published var questions: [QuizQuestion] = []
    @Published var currentIndex: Int = 0
    @Published var selectedAnswers: [String: Int] = [:] // questionId -> selectedIndex

    @Published var remainingSeconds: Int? = nil
    @Published var result: QuizResult? = nil

    private var endAt: Date? = nil
    private var startedAt: Date? = nil
    private var timer: Timer? = nil
    private var hasStarted: Bool = false

    init(bankKey: String, lessonId: String?, isUnlimited: Bool, minutes: Int) {
        self.bankKey = bankKey
        self.lessonId = lessonId
        self.isUnlimited = isUnlimited
        self.durationSeconds = isUnlimited ? nil : max(1, minutes) * 60
    }

    deinit {
        timer?.invalidate()
    }

    func startIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        start()
    }

    func start() {
        isLoading = true
        errorMessage = nil
        result = nil
        selectedAnswers = [:]
        currentIndex = 0
        questions = []
        timer?.invalidate()
        timer = nil
        remainingSeconds = nil

        // ✅ Quy ước:
        // - practice / nil: seed "practice_all" để đảm bảo có câu, fetch nil để lấy tổng hợp
        // - lessonX: seed lessonX và fetch lessonX
        let fetchLessonId = normalizedFetchLessonId(from: lessonId) // nil => tổng hợp
        let seedLessonId = normalizedSeedLessonId(from: lessonId)   // luôn có giá trị để seed

        MyDatabase.shared.seedQuestionsIfEmpty(subjectKey: bankKey, lessonId: seedLessonId) { [weak self] seedResult in
            guard let self else { return }

            switch seedResult {
            case .failure(let err):
                DispatchQueue.main.async {
                    self.isLoading = false
                    self.errorMessage = "Không seed được questions: \(err.localizedDescription)"
                }

            case .success:
                MyDatabase.shared.fetchQuestions(subjectKey: self.bankKey, lessonId: fetchLessonId) { [weak self] fetchResult in
                    guard let self else { return }

                    DispatchQueue.main.async {
                        self.isLoading = false

                        switch fetchResult {
                        case .failure(let err):
                            self.errorMessage = "Không tải được câu hỏi: \(err.localizedDescription)"

                        case .success(let all):
                            if all.isEmpty {
                                let l = fetchLessonId ?? "tổng hợp"
                                self.errorMessage = "Không có câu hỏi cho \(self.bankKey) - \(l)"
                                return
                            }

                            let shuffled = all.shuffled()
                            self.questions = Array(shuffled.prefix(self.fixedTotal))

                            self.startedAt = Date()

                            if let dur = self.durationSeconds {
                                self.endAt = Date().addingTimeInterval(TimeInterval(dur))
                                self.remainingSeconds = dur
                                self.startTimer()
                            } else {
                                self.remainingSeconds = nil
                            }
                        }
                    }
                }
            }
        }
    }

    // MARK: - Actions

    func selectAnswer(_ index: Int) {
        guard currentIndex >= 0, currentIndex < questions.count else { return }
        let q = questions[currentIndex]
        selectedAnswers[q.id] = index
    }

    func goPrev() {
        currentIndex = max(0, currentIndex - 1)
    }

    func goNext() {
        currentIndex = min(max(0, questions.count - 1), currentIndex + 1)
    }

    func submit(isAuto: Bool = false) {
        guard result == nil else { return }

        timer?.invalidate()
        timer = nil

        let correctCount = questions.reduce(0) { partial, q in
            let user = selectedAnswers[q.id]
            return partial + ((user == q.correctIndex) ? 1 : 0)
        }

        let timeUsed: Int?
        if let startedAt, let dur = durationSeconds {
            let used = Int(Date().timeIntervalSince(startedAt))
            timeUsed = min(dur, max(0, used))
        } else {
            timeUsed = nil
        }

        let review: [QuizReviewItem] = questions.enumerated().map { idx, q in
            let userIndex = selectedAnswers[q.id]
            let userChoice = userIndex.map { q.optionText(for: $0) } ?? "Chưa chọn"
            let correctChoice = q.optionText(for: q.correctIndex)
            let isCorrect = (userIndex == q.correctIndex)

            return QuizReviewItem(
                id: q.id,
                title: "Câu \(idx + 1): \(q.questionText)",
                userChoice: userChoice,
                correctChoice: correctChoice,
                isCorrect: isCorrect
            )
        }

        self.result = QuizResult(
            fixedTotal: fixedTotal,
            correctCount: correctCount,
            timeUsedSeconds: timeUsed,
            reviewItems: review
        )
    }

    // MARK: - Timer

    private func startTimer() {
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.tick()
        }
    }

    private func tick() {
        guard let endAt else { return }
        let remain = Int(endAt.timeIntervalSince(Date()))
        if remain <= 0 {
            DispatchQueue.main.async {
                self.remainingSeconds = 0
                self.submit(isAuto: true)
            }
        } else {
            DispatchQueue.main.async {
                self.remainingSeconds = remain
            }
        }
    }

    // MARK: - Helpers

    func progressText() -> String {
        "Câu \(min(currentIndex + 1, max(1, questions.count)))/\(max(1, questions.count))"
    }

    func timeBadgeText() -> String {
        if isUnlimited { return "Không giới hạn thời gian" }
        guard let remainingSeconds else { return "" }
        let m = remainingSeconds / 60
        let s = remainingSeconds % 60
        return String(format: "%02d:%02d", m, s)
    }

    private func normalizedFetchLessonId(from raw: String?) -> String? {
        guard let raw else { return nil }
        if raw == "practice" || raw == "practice_all" { return nil } // nil = tổng hợp
        return raw
    }

    private func normalizedSeedLessonId(from raw: String?) -> String {
        // seed luôn cần 1 lessonId cụ thể
        guard let raw else { return "practice_all" }
        if raw == "practice" { return "practice_all" }
        return raw
    }
}
