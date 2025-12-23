//
//  LessonModel.swift
//  appHocTap
//
//  Created by User on 22.12.2025.
//

import Foundation

struct LessonModel: Identifiable, Codable {
    var id: String
    var name: String
    var description: String
    var subject: String    // Lưu tên môn (Ví dụ: "Toán")
    var grade: String      // Lưu tên lớp (Ví dụ: "Lớp 1")
    var iconName: String
    var iconColor: String
    
    // Hàm chuyển đổi Model sang Dictionary để lưu lên Firebase
    func toDictionary() -> [String: Any] {
        return [
            "id": id,
            "name": name,
            "description": description,
            "subject": subject,
            "grade": grade,
            "iconName": iconName,
            "iconColor": iconColor
        ]
    }
}
