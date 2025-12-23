import SwiftUI

struct LessonRowModel: Identifiable {

    enum Status {
        case none
        case done
        case notDone
    }

    let id = UUID()
    let iconSystemName: String
    let iconBg: Color
    let title: String
    let subtitle: String
    let status: Status

    /// Key dùng để lấy câu hỏi theo từng bài
    /// ví dụ: "practice", "lesson1", "lesson2"
    let lessonKey: String
}

