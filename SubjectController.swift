//
//  SubjectController.swift
//  appHocTap
//
//  Created by User on 21.12.2025.
//

import Foundation

class SubjectController {
    static let shared = SubjectController()
    // Hàm lấy danh sách môn học
    // completion: Trả về một mảng [SubjectModel] hoặc lỗi (String)
    func fetchSubjects(completion: @escaping ([SubjectModel]?, String?) -> Void) {
        
        // Gọi xuống tầng Database (DAL)
        MyDatabase.shared.getSubjects { subjects in
            
            // Kiểm tra xem có dữ liệu không
            if subjects.isEmpty {
                completion(nil, "Không tìm thấy môn học nào trên hệ thống.")
            } else {
                // Sắp xếp thứ tự môn học cố định cho đẹp (Toán -> Văn -> Anh)
                // Nếu không cần sắp xếp thì cứ trả về subjects
                let sortedSubjects = subjects.sorted { $0.id > $1.id } // Ví dụ sắp xếp theo ID
                completion(sortedSubjects, nil)
            }
        }
    }
}
