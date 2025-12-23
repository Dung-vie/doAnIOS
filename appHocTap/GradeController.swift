//
//  GradeController.swift
//  appHocTap
//
//  Created by User on 22.12.2025.
//

import Foundation

class GradeController {
    
    static let shared = GradeController()
    
    private init() {}
    
    // Hàm gọi database và trả về danh sách lớp
    func fetchGrades(completion: @escaping ([GradeModel]) -> Void) {
        MyDatabase.shared.getGrades { grades in
            // Sắp xếp theo ID tăng dần (1 -> 5) để hiển thị menu cho đẹp
            // Vì ID trong Firebase là String ("1", "2"), ta ép kiểu sang Int để so sánh
            let sortedGrades = grades.sorted {
                (Int($0.id) ?? 0) < (Int($1.id) ?? 0)
            }
            completion(sortedGrades)
        }
    }
}
