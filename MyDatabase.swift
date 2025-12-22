//
//  MyDatabase.swift
//  appHocTap
//
//  Created by  User on 21.12.2025.
//

import Firebase
import FirebaseDatabase

class MyDatabase {
    static let shared = MyDatabase()
    let dbRef: DatabaseReference

    private init() {
        dbRef = Database.database().reference()
    }

    // Ham tai danh sach mon hoc
        func getSubjects(completion: @escaping ([SubjectModel]) -> Void) {
            let ref = dbRef.child("subjects")
            
            ref.observeSingleEvent(of: .value) { snapshot in
                var loadedSubjects: [SubjectModel] = []
                
                // Duyệt qua từng con (toan, van, anh)
                for child in snapshot.children {
                    if let snap = child as? DataSnapshot,
                       let value = snap.value as? [String: Any] {
                        
                        let id = snap.key // lấy được chữ: "toan", "van", "anh"
                        let name = value["name"] as? String ?? ""
                        let subtitle = value["subtitle"] as? String ?? ""
                        let icon = value["icon"] as? String ?? "questionmark"
                        let color = value["color"] as? String ?? "gray"
                        
                        let subject = SubjectModel(id: id, name: name, subtitle: subtitle, icon: icon, colorString: color)
                        loadedSubjects.append(subject)
                    }
                }
                // Trả về danh sách
                completion(loadedSubjects)
            }
        }
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

            // Convert Model -> Dictionary
            if let data = try? JSONEncoder().encode(profile),
               let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {

                self.dbRef.child("users").child(user.uid).setValue(dict)
            }

            completion(.success(user))
        }
    }

    // --- 3. HÀM LƯU KẾT QUẢ (SAVE) ---
    func saveQuizResult(score: Int, total: Int, wrongAnswers: [ReviewItem], completion: @escaping (Bool) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Convert list câu sai sang dạng Dictionary
        let wrongData = wrongAnswers.map { $0.toDict() }
        
        let dict: [String: Any] = [
            "score": score,
            "totalQuestions": total,
            "dateString": getCurrentDate(),
            "timestamp": ServerValue.timestamp(), // Để sắp xếp
            "wrongAnswers": wrongData
        ]
        
        // Lưu vào: users -> UID -> history -> AutoID
        dbRef.child("users").child(uid).child("history").childByAutoId().setValue(dict) { error, _ in
            completion(error == nil)
        }
    }
    
    // --- 4. HÀM LẤY LỊCH SỬ (GET HISTORY) ---
    func getHistory(completion: @escaping ([QuizHistoryItem]) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion([])
            return
        }
        
        let ref = dbRef.child("users").child(uid).child("history")
        
        // Sắp xếp theo thời gian (timestamp)
        ref.queryOrdered(byChild: "timestamp").observeSingleEvent(of: .value) { snapshot in
            var tempHistory: [QuizHistoryItem] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let val = snap.value as? [String: Any] {
                    
                    // Convert JSON Firebase -> QuizHistoryItem
                    let item = QuizHistoryItem(id: snap.key, data: val)
                    tempHistory.append(item)
                }
            }
            // Đảo ngược mảng để cái mới nhất lên đầu (vì Firebase sort cũ -> mới)
            completion(tempHistory.reversed())
        }
    }
}

	
