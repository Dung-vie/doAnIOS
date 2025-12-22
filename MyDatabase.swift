import Firebase
import FirebaseDatabase
import FirebaseAuth

final class MyDatabase {
    static let shared = MyDatabase()
    let dbRef: DatabaseReference

    private init() {
        dbRef = Database.database().reference()
    }

    // MARK: - Register (giữ nguyên của bạn)
    func register(email: String,
                  password: String,
                  fullName: String,
                  completion: @escaping (Result<User, Error>) -> Void) {

        Auth.auth().createUser(withEmail: email, password: password) { result, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user else {
                completion(.failure(
                    NSError(domain: "", code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Không lấy được user"])
                ))
                return
            }

            let profile = UserProfile(uid: user.uid, fullName: fullName, email: email)

            if let data = try? JSONEncoder().encode(profile),
               let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                self.dbRef.child("users").child(user.uid).setValue(dict)
            }

            completion(.success(user))
        }
    }

    // MARK: - Questions (schema mới)

    /// Seed câu hỏi theo subjectKey + lessonId
    /// - subjectKey: "toan_1", "van_1", "anh_1"
    /// - lessonId: "lesson1", "lesson2", ... hoặc "practice_all"
    func seedQuestionsIfEmpty(
        subjectKey: String,
        lessonId: String,
        completion: @escaping (Result<Void, Error>) -> Void
    ) {
        guard let info = Self.parseSubjectKey(subjectKey) else {
            completion(.failure(NSError(
                domain: "", code: -2,
                userInfo: [NSLocalizedDescriptionKey: "subjectKey không hợp lệ: \(subjectKey)"]
            )))
            return
        }

        let ref = dbRef.child("questions")

        ref.observeSingleEvent(of: .value) { snapshot in
            // ✅ Check xem đã có câu nào đúng subject+grade+lessonId chưa
            var found = false
            for child in snapshot.children {
                guard let snap = child as? DataSnapshot,
                      let dict = snap.value as? [String: Any] else { continue }

                let grade = dict["grade"] as? Int
                let subject = dict["subject"] as? String
                let lId = dict["lessonId"] as? String

                if grade == info.grade, subject == info.subject, lId == lessonId {
                    found = true
                    break
                }
            }

            if found {
                completion(.success(()))
                return
            }

            // ✅ Seed theo đúng môn + lớp + lessonId
            let samples = Self.sampleQuestions(subject: info.subject, grade: info.grade, lessonId: lessonId)

            let group = DispatchGroup()
            var lastError: Error?

            for item in samples {
                group.enter()

                let id = item.id  // key chính là id (ví dụ: toan_1_lesson1_q001)
                ref.child(id).setValue(item.data) { error, _ in
                    if let error = error { lastError = error }
                    group.leave()
                }
            }

            group.notify(queue: .main) {
                if let err = lastError {
                    completion(.failure(err))
                } else {
                    completion(.success(()))
                }
            }
        } withCancel: { error in
            completion(.failure(error))
        }
    }

    /// Fetch câu hỏi theo subjectKey + lessonId (hoặc nil để lấy tổng hợp)
    func fetchQuestions(
        subjectKey: String,
        lessonId: String? = nil,
        completion: @escaping (Result<[QuizQuestion], Error>) -> Void
    ) {
        guard let info = Self.parseSubjectKey(subjectKey) else {
            completion(.failure(NSError(
                domain: "", code: -2,
                userInfo: [NSLocalizedDescriptionKey: "subjectKey không hợp lệ: \(subjectKey)"]
            )))
            return
        }

        dbRef.child("questions").observeSingleEvent(of: .value) { snapshot in
            var items: [QuizQuestion] = []

            for child in snapshot.children {
                guard let snap = child as? DataSnapshot,
                      let dict = snap.value as? [String: Any] else { continue }

                let grade = dict["grade"] as? Int
                let subject = dict["subject"] as? String
                if grade != info.grade || subject != info.subject { continue }

                // ✅ nếu có lessonId thì lọc theo bài
                if let lessonId = lessonId {
                    let l = dict["lessonId"] as? String
                    if l != lessonId { continue }
                }

                guard
                    let questionText = dict["questionText"] as? String,
                    let optionA = dict["optionA"] as? String,
                    let optionB = dict["optionB"] as? String,
                    let optionC = dict["optionC"] as? String,
                    let optionD = dict["optionD"] as? String,
                    let correctIndex = dict["correctIndex"] as? Int
                else { continue }

                let explanation = dict["explanation"] as? String

                items.append(
                    QuizQuestion(
                        id: snap.key,
                        questionText: questionText,
                        optionA: optionA,
                        optionB: optionB,
                        optionC: optionC,
                        optionD: optionD,
                        correctIndex: correctIndex,
                        explanation: explanation
                    )
                )
            }

            completion(.success(items))
        } withCancel: { error in
            completion(.failure(error))
        }
    }

    // MARK: - Helpers

    /// "toan_1" -> subject="toan", grade=1
    private static func parseSubjectKey(_ key: String) -> (subject: String, grade: Int)? {
        let parts = key.split(separator: "_").map(String.init)
        guard parts.count >= 2 else { return nil }
        guard let grade = Int(parts.last ?? "") else { return nil }
        let subject = parts.dropLast().joined(separator: "_")
        return (subject: subject, grade: grade)
    }

    // MARK: - Sample data theo từng bài

    private struct SampleItem {
        let id: String
        let data: [String: Any]
    }

    private static func sampleQuestions(subject: String, grade: Int, lessonId: String) -> [SampleItem] {

        // helper tạo id tránh trùng
        func makeId(_ suffix: String) -> String {
            "\(subject)_\(grade)_\(lessonId)_\(suffix)"
        }

        // ===== TOÁN LỚP 1 =====
        if subject == "toan", grade == 1 {
            switch lessonId {
            case "lesson1": // Đếm số 1-10
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "toan", "lessonId": "lesson1",
                        "questionText": "Số nào lớn hơn 7?",
                        "optionA": "6", "optionB": "7", "optionC": "8", "optionD": "5",
                        "correctIndex": 2,
                        "explanation": "8 lớn hơn 7"
                    ]),
                    .init(id: makeId("q002"), data: [
                        "grade": 1, "subject": "toan", "lessonId": "lesson1",
                        "questionText": "Dãy số đúng là?",
                        "optionA": "1 2 4", "optionB": "1 2 3", "optionC": "2 1 3", "optionD": "3 2 1",
                        "correctIndex": 1
                    ])
                ]

            case "lesson2": // So sánh lớn hơn, nhỏ hơn
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "toan", "lessonId": "lesson2",
                        "questionText": "5 ___ 8",
                        "optionA": ">", "optionB": "<", "optionC": "=", "optionD": "Không biết",
                        "correctIndex": 1,
                        "explanation": "5 nhỏ hơn 8 nên chọn <"
                    ]),
                    .init(id: makeId("q002"), data: [
                        "grade": 1, "subject": "toan", "lessonId": "lesson2",
                        "questionText": "9 ___ 9",
                        "optionA": ">", "optionB": "<", "optionC": "=", "optionD": "Không biết",
                        "correctIndex": 2
                    ])
                ]

            case "lesson3": // Phép cộng
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "toan", "lessonId": "lesson3",
                        "questionText": "2 + 3 = ?",
                        "optionA": "4", "optionB": "5", "optionC": "6", "optionD": "7",
                        "correctIndex": 1,
                        "explanation": "2 + 3 = 5"
                    ]),
                    .init(id: makeId("q002"), data: [
                        "grade": 1, "subject": "toan", "lessonId": "lesson3",
                        "questionText": "1 + 6 = ?",
                        "optionA": "7", "optionB": "6", "optionC": "8", "optionD": "5",
                        "correctIndex": 0
                    ])
                ]

            case "lesson4": // Hình học
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "toan", "lessonId": "lesson4",
                        "questionText": "Hình vuông có mấy cạnh?",
                        "optionA": "2", "optionB": "3", "optionC": "4", "optionD": "5",
                        "correctIndex": 2
                    ]),
                    .init(id: makeId("q002"), data: [
                        "grade": 1, "subject": "toan", "lessonId": "lesson4",
                        "questionText": "Hình tròn có góc không?",
                        "optionA": "Có", "optionB": "Không", "optionC": "2 góc", "optionD": "4 góc",
                        "correctIndex": 1
                    ])
                ]

            case "lesson5": // Phép trừ
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "toan", "lessonId": "lesson5",
                        "questionText": "5 - 2 = ?",
                        "optionA": "1", "optionB": "2", "optionC": "3", "optionD": "4",
                        "correctIndex": 2
                    ]),
                    .init(id: makeId("q002"), data: [
                        "grade": 1, "subject": "toan", "lessonId": "lesson5",
                        "questionText": "9 - 1 = ?",
                        "optionA": "8", "optionB": "7", "optionC": "6", "optionD": "9",
                        "correctIndex": 0
                    ])
                ]

            case "practice_all":
                // luyện tập tổng hợp riêng (nếu bạn muốn)
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "toan", "lessonId": "practice_all",
                        "questionText": "Số nào là số chẵn?",
                        "optionA": "3", "optionB": "5", "optionC": "8", "optionD": "9",
                        "correctIndex": 2
                    ]),
                    .init(id: makeId("q002"), data: [
                        "grade": 1, "subject": "toan", "lessonId": "practice_all",
                        "questionText": "3 + 4 = ?",
                        "optionA": "6", "optionB": "7", "optionC": "8", "optionD": "9",
                        "correctIndex": 1
                    ])
                ]

            default:
                break
            }
        }

        // ===== VĂN LỚP 1 =====
        if subject == "van", grade == 1 {
            switch lessonId {
            case "lesson1": // Bảng chữ cái
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "van", "lessonId": "lesson1",
                        "questionText": "Chữ cái nào đứng sau chữ A?",
                        "optionA": "B", "optionB": "C", "optionC": "D", "optionD": "E",
                        "correctIndex": 0
                    ])
                ]
            case "lesson2": // Từ vựng cơ bản
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "van", "lessonId": "lesson2",
                        "questionText": "Từ nào chỉ con vật?",
                        "optionA": "cây", "optionB": "mèo", "optionC": "bàn", "optionD": "mưa",
                        "correctIndex": 1
                    ])
                ]
            case "lesson3": // Đọc hiểu ngắn
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "van", "lessonId": "lesson3",
                        "questionText": "Câu nào là câu hỏi?",
                        "optionA": "Trời đẹp quá.",
                        "optionB": "Bạn ăn cơm chưa?",
                        "optionC": "Mình đi học.",
                        "optionD": "Hôm nay thứ hai.",
                        "correctIndex": 1
                    ])
                ]
            case "lesson4": // Kể chuyện
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "van", "lessonId": "lesson4",
                        "questionText": "Từ nào là danh từ?",
                        "optionA": "chạy", "optionB": "đẹp", "optionC": "bàn", "optionD": "nhanh",
                        "correctIndex": 2
                    ])
                ]
            case "lesson5": // Tập viết
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "van", "lessonId": "lesson5",
                        "questionText": "Chọn từ viết đúng chính tả:",
                        "optionA": "con meo", "optionB": "con mèo", "optionC": "con méo", "optionD": "con meò",
                        "correctIndex": 1
                    ])
                ]
            case "practice_all":
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "van", "lessonId": "practice_all",
                        "questionText": "Từ nào là danh từ?",
                        "optionA": "chạy", "optionB": "đẹp", "optionC": "bàn", "optionD": "nhanh",
                        "correctIndex": 2
                    ])
                ]
            default:
                break
            }
        }

        // ===== ANH LỚP 1 =====
        if subject == "anh", grade == 1 {
            switch lessonId {
            case "lesson1": // Alphabet
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "anh", "lessonId": "lesson1",
                        "questionText": "Which letter comes after A?",
                        "optionA": "B", "optionB": "C", "optionC": "D", "optionD": "E",
                        "correctIndex": 0
                    ])
                ]
            case "lesson2": // Vocabulary
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "anh", "lessonId": "lesson2",
                        "questionText": "Apple nghĩa là gì?",
                        "optionA": "Quả táo", "optionB": "Quả cam", "optionC": "Quả nho", "optionD": "Quả lê",
                        "correctIndex": 0
                    ])
                ]
            case "lesson3": // Pronunciation
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "anh", "lessonId": "lesson3",
                        "questionText": "Choose the correct: I ___ a student.",
                        "optionA": "am", "optionB": "is", "optionC": "are", "optionD": "be",
                        "correctIndex": 0
                    ])
                ]
            case "lesson4": // Reading
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "anh", "lessonId": "lesson4",
                        "questionText": "Goodbye nghĩa là gì?",
                        "optionA": "Xin chào", "optionB": "Tạm biệt", "optionC": "Cảm ơn", "optionD": "Xin lỗi",
                        "correctIndex": 1
                    ])
                ]
            case "lesson5": // Writing
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "anh", "lessonId": "lesson5",
                        "questionText": "Choose a correct word: C _ T",
                        "optionA": "A", "optionB": "O", "optionC": "E", "optionD": "I",
                        "correctIndex": 1,
                        "explanation": "C O T"
                    ])
                ]
            case "practice_all":
                return [
                    .init(id: makeId("q001"), data: [
                        "grade": 1, "subject": "anh", "lessonId": "practice_all",
                        "questionText": "Apple nghĩa là gì?",
                        "optionA": "Quả táo", "optionB": "Quả cam", "optionC": "Quả nho", "optionD": "Quả lê",
                        "correctIndex": 0
                    ])
                ]
            default:
                break
            }
        }

        // fallback
        return [
            .init(id: makeId("q001"), data: [
                "grade": grade, "subject": subject, "lessonId": lessonId,
                "questionText": "Chưa có bộ câu hỏi cho \(subject)_\(grade) - \(lessonId)",
                "optionA": "A", "optionB": "B", "optionC": "C", "optionD": "D",
                "correctIndex": 0
            ])
        ]
    }
}
