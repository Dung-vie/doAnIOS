//
//  MyDatabase.swift
//  appHocTap
//
//  Created by  User on 21.12.2025.
//

import Firebase
import FirebaseDatabase
import FirebaseAuth

class MyDatabase {
    static let shared = MyDatabase()
    let dbRef: DatabaseReference
    
    private init() {
        dbRef = Database.database().reference()
    }
    
    // --- 1. Lấy toàn bộ câu hỏi ---
    func getQuestions(completion: @escaping ([Question]) -> Void) {
        let ref = dbRef.child("questions")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            var loadedQuestions: [Question] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any] {
                    
                    let id = snap.key
                    let content = value["content"] as? String ?? ""
                    let correctAnswerIndex = value["correctAnswerIndex"] as? Int ?? 0
                    let lessonId = value["lessonId"] as? String ?? ""
                    
                    // Parse mảng answers
                    var answers: [Answer] = []
                    if let answersData = value["answers"] as? [[String: Any]] {
                        for ansDict in answersData {
                            let ansId = ansDict["id"] as? String ?? UUID().uuidString
                            let ansContent = ansDict["content"] as? String ?? ""
                            answers.append(Answer(id: ansId, content: ansContent))
                        }
                    }
                    
                    let question = Question(
                        id: id,
                        content: content,
                        answers: answers,
                        correctAnswerIndex: correctAnswerIndex,
                        lessonId: lessonId
                    )
                    loadedQuestions.append(question)
                }
            }
            completion(loadedQuestions)
        }
    }
    
    // --- 2. Xóa câu hỏi ---
    func deleteQuestion(id: String, completion: @escaping (Error?) -> Void) {
        dbRef.child("questions").child(id).removeValue { error, _ in
            completion(error)
        }
    }
    
    // Hàm thêm câu hỏi mới
    func addQuestion(_ question: Question, completion: @escaping (Error?) -> Void) {
        // Lưu vào node "questions" -> "question_id"
        let ref = dbRef.child("questions").child(question.id)
        
        ref.setValue(question.toDictionary()) { error, _ in
            completion(error)
        }
    }
    
    // Hàm xóa bài học trên Firebase dựa vào ID
    func deleteLesson(id: String, completion: @escaping (Error?) -> Void) {
        let ref = dbRef.child("lessons").child(id)
        
        // Lệnh removeValue sẽ xóa node đó khỏi Firebase
        ref.removeValue { error, _ in
            completion(error)
        }
    }
    
    // Hàm thêm bài học mới lên Firebase
    // lesson: Đối tượng LessonModel chứa dữ liệu
    // completion: Trả về lỗi nếu có (nil nếu thành công)
    func addLesson(_ lesson: LessonModel, completion: @escaping (Error?) -> Void) {
        
        // Tạo reference đến node "lessons" -> "lesson_id"
        let ref = dbRef.child("lessons").child(lesson.id)
        
        // Lưu dữ liệu dạng Dictionary
        ref.setValue(lesson.toDictionary()) { error, _ in
            completion(error)
        }
    }
    // Hàm lấy danh sách Lớp học từ node "grades"
    func getGrades(completion: @escaping ([GradeModel]) -> Void) {
        let ref = dbRef.child("grades") // Trỏ vào node "grades"
        
        ref.observeSingleEvent(of: .value) { snapshot in
            var loadedGrades: [GradeModel] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any] {
                    
                    let id = snap.key // Lấy key là "1", "2"...
                    let name = value["name"] as? String ?? "Lớp ?"
                    let icon = value["icon"] as? String ?? "book"
                    let color = value["color"] as? String ?? "gray"
                    
                    let grade = GradeModel(id: id, name: name, icon: icon, colorString: color)
                    loadedGrades.append(grade)
                }
            }
            completion(loadedGrades)
        }
    }
    
    // Ham tai danh sach mon hoc
    func getSubjects(completion: @escaping ([SubjectModel]) -> Void) {
        let ref = dbRef.child("subject")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            // In ra xem Firebase trả về cái gì
            print("Snapshot từ Firebase: \(snapshot.value ?? "nil")")
            
            var loadedSubjects: [SubjectModel] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any] {
                    
                    let id = snap.key
                    let name = value["name"] as? String ?? "No Name"
                    let subtitle = value["subtitle"] as? String ?? ""
                    let icon = value["icon"] as? String ?? "questionmark"
                    let color = value["color"] as? String ?? "gray"
                    
                    print("-> Tìm thấy môn: \(name) - màu: \(color)") // Debug dòng này
                    
                    let subject = SubjectModel(id: id, name: name, subtitle: subtitle, icon: icon, colorString: color)
                    loadedSubjects.append(subject)
                }
            }
            completion(loadedSubjects)
        }
    }
    
    // Lưu profile người dùng vào /users/{uid}
        func saveUser(_ profile: UserProfile, completion: @escaping (Bool) -> Void) {
            let userRef = dbRef.child("users").child(profile.uid)
            let data: [String: Any] = [
                "uid": profile.uid,
                "fullName": profile.fullName,
                "email": profile.email,
                "grade": profile.grade,
                "role": profile.role
            ]
            
            userRef.setValue(data) { error, _ in
                if let error = error {
                    print("Lỗi lưu user: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
        
        // Lấy role của user theo uid
        func getRole(for uid: String, completion: @escaping (Int?) -> Void) {
            let userRef = dbRef.child("users").child(uid)
            userRef.observeSingleEvent(of: .value) { snapshot in
                guard let data = snapshot.value as? [String: Any],
                      let role = data["role"] as? Int else {
                    completion(nil)
                    return
                }
                completion(role)
            }
        }
}


