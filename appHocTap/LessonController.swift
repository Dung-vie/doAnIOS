//
//  LessonController.swift
//  appHocTap
//
//  Created by User on 22.12.2025.
//

import Foundation
import FirebaseDatabase // Nhớ import cái này để dùng DataSnapshot

class LessonController {
    
    static let shared = LessonController()
    
    private init() {}
    
    // 1. Hàm thêm bài học
    func addNewLesson(name: String,
                      description: String,
                      subject: String,
                      grade: String,
                      iconName: String,
                      iconColor: String,
                      completion: @escaping (Bool, String?) -> Void) {
        
        let newId = UUID().uuidString
        
        let newLesson = LessonModel(
            id: newId,
            name: name,
            description: description,
            subject: subject,
            grade: grade,
            iconName: iconName,
            iconColor: iconColor
        )
        
        MyDatabase.shared.addLesson(newLesson) { error in
            if let error = error {
                completion(false, error.localizedDescription)
            } else {
                completion(true, nil)
            }
        }
    }
    
    // --- 2. Hàm lấy danh sách bài học ---
    func fetchAllLessons(completion: @escaping ([LessonModel]) -> Void) {
        // Gọi trực tiếp vào node "lessons" trên Firebase
        let ref = Database.database().reference().child("lessons")
        
        ref.observeSingleEvent(of: .value) { snapshot in
            var loadedLessons: [LessonModel] = []
            
            for child in snapshot.children {
                if let snap = child as? DataSnapshot,
                   let value = snap.value as? [String: Any] {
                    
                    let id = snap.key
                    let name = value["name"] as? String ?? ""
                    let description = value["description"] as? String ?? ""
                    let subject = value["subject"] as? String ?? ""
                    let grade = value["grade"] as? String ?? ""
                    let iconName = value["iconName"] as? String ?? ""
                    let iconColor = value["iconColor"] as? String ?? ""
                    
                    let lesson = LessonModel(
                        id: id,
                        name: name,
                        description: description,
                        subject: subject,
                        grade: grade,
                        iconName: iconName,
                        iconColor: iconColor
                    )
                    loadedLessons.append(lesson)
                }
            }
            // Trả về danh sách
            completion(loadedLessons)
        }
    }
    
    // --- 3. Hàm xóa bài học ---
    func deleteLesson(id: String, completion: @escaping (Bool) -> Void) {
            // Gọi xuống Database
            MyDatabase.shared.deleteLesson(id: id) { error in
                if error == nil {
                    // Không có lỗi -> Xóa thành công
                    completion(true)
                } else {
                    // Có lỗi -> Xóa thất bại
                    completion(false)
                }
            }
        }
    
    // --- 4.Hàm cập nhật bài học ---
        func updateLesson(_ lesson: LessonModel, completion: @escaping (Bool) -> Void) {
            // Tận dụng hàm addLesson của Database vì nó dùng setValue (ghi đè nếu ID đã tồn tại)
            MyDatabase.shared.addLesson(lesson) { error in
                if error == nil {
                    completion(true)
                } else {
                    completion(false)
                }
            }
        }
}
