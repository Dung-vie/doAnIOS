//
//  LessonManager.swift
//  appHocTap
//

import SwiftUI

struct LessonManager: View {

    @Environment(\.dismiss) private var dismiss

    @State private var searchText = ""
    @State private var selectedSubject = "Tất cả môn"
    @State private var selectedGrade = "Tất cả lớp"

    // Danh sách dữ liệu thật từ Firebase
    @State private var gradeList: [GradeModel] = []
    @State private var subjectList: [SubjectModel] = []
    
    // --- SỬA: Dùng trực tiếp [LessonModel] ---
    @State private var lessons: [LessonModel] = []
    // -----------------------------------------

    @State private var showDeleteAlert = false
    @State private var lessonToDelete: LessonModel? // Sửa kiểu dữ liệu ở đây luôn

    // Logic lọc bài học
    var filteredLessons: [LessonModel] {
        lessons.filter { lesson in
            // 1. Lọc theo tên (search) - Lưu ý: LessonModel dùng 'name', không phải 'title'
            let matchName = searchText.isEmpty || lesson.name.localizedCaseInsensitiveContains(searchText)
            
            // 2. Lọc theo môn
            let matchSubject = selectedSubject == "Tất cả môn" || lesson.subject == selectedSubject
            
            // 3. Lọc theo lớp
            let matchGrade = selectedGrade == "Tất cả lớp" || lesson.grade == selectedGrade
            
            return matchName && matchSubject && matchGrade
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    header
                    searchBar
                    filterRow
                    
                    // Hiển thị danh sách hoặc thông báo rỗng
                    if filteredLessons.isEmpty {
                        VStack(spacing: 10) {
                            Image(systemName: "doc.text.magnifyingglass")
                                .font(.largeTitle)
                                .foregroundColor(.gray)
                            Text("Chưa có bài học nào.")
                                .foregroundColor(.gray)
                        }
                        .padding(.top, 40)
                    } else {
                        lessonList
                    }
                }
                .padding(.bottom, 24)
            }
            .background(Color(white: 0.96))
            .navigationBarHidden(true)
            .alert("Xóa bài học?", isPresented: $showDeleteAlert, presenting: lessonToDelete) { lesson in
                Button("Xóa vĩnh viễn", role: .destructive) {
                    deleteLessonReal(id: lesson.id)
                }
                Button("Hủy", role: .cancel) {}
            } message: { lesson in
                Text("Bạn có chắc muốn xóa bài '\(lesson.name)' không?")
            }
        }
        .onAppear {
            loadAllData()
        }
    }
    
    // --- HÀM TẢI DỮ LIỆU ---
    func loadAllData() {
        // 1. Tải Môn & Lớp (Cho Menu lọc)
        GradeController.shared.fetchGrades { grades in
            DispatchQueue.main.async { self.gradeList = grades }
        }
        SubjectController.shared.fetchSubjects { (subjects, _) in
            if let data = subjects {
                DispatchQueue.main.async { self.subjectList = data }
            }
        }
        
        // 2. Tải danh sách Bài học (Dùng LessonController đã viết)
        LessonController.shared.fetchAllLessons { realLessons in
            DispatchQueue.main.async {
                self.lessons = realLessons // Gán trực tiếp vì cùng kiểu LessonModel
            }
        }
    }
    
    // Hàm xóa bài học
    func deleteLessonReal(id: String) {
        // 1. Gọi Controller để xóa trên Firebase
        LessonController.shared.deleteLesson(id: id) { success in
            if success {
                // 2. Nếu Firebase xóa thành công -> Cập nhật giao diện ngay lập tức
                DispatchQueue.main.async {
                    // Tìm vị trí bài học trong mảng và xóa nó đi
                    if let index = lessons.firstIndex(where: { $0.id == id }) {
                        withAnimation { // Thêm hiệu ứng cho đẹp
                            lessons.remove(at: index)
                        }
                    }
                }
            } else {
                print("Lỗi: Không thể xóa bài học này.")
            }
        }
    }
}

// MARK: - Components UI
extension LessonManager {

    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "arrow.left")
                    .font(.title3.weight(.semibold))
            }
            Spacer()
            Text("Quản lý Bài Học")
                .font(.system(size: 20, weight: .bold))
            Spacer()
            
            NavigationLink(destination: AddLesson()) {
                HStack {
                    Image(systemName: "plus")
                    Text("Thêm")
                        .fontWeight(.semibold)
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(Color.green)
                .foregroundColor(.white)
                .clipShape(Capsule())
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 12)
    }

    private var searchBar: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            TextField("Tìm kiếm tên bài học...", text: $searchText)
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 14))
        .padding(.horizontal, 16)
    }

    private var filterRow: some View {
        HStack(spacing: 12) {
            // Menu Môn
            Menu {
                Button("Tất cả môn") { selectedSubject = "Tất cả môn" }
                ForEach(subjectList) { subject in
                    Button(subject.name) { selectedSubject = subject.name }
                }
            } label: {
                filterButton(title: selectedSubject, icon: "book")
            }

            // Menu Lớp
            Menu {
                Button("Tất cả lớp") { selectedGrade = "Tất cả lớp" }
                ForEach(gradeList) { grade in
                    Button(grade.name) { selectedGrade = grade.name }
                }
            } label: {
                filterButton(title: selectedGrade, icon: "graduationcap")
            }
        }
        .padding(.horizontal, 16)
    }

    private var lessonList: some View {
        VStack(spacing: 14) {
            // Duyệt danh sách LessonModel đã lọc
            ForEach(filteredLessons) { lesson in
                lessonCard(lesson)
            }
        }
        .padding(.horizontal, 16)
    }

    private func filterButton(title: String, icon: String) -> some View {
        HStack {
            Image(systemName: icon)
            Text(title).lineLimit(1)
            Image(systemName: "chevron.down")
        }
        .font(.system(size: 15, weight: .semibold))
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(Color.white)
        .clipShape(Capsule())
    }

    // --- Card hiển thị theo LessonModel ---
    private func lessonCard(_ lesson: LessonModel) -> some View {
        HStack(spacing: 14) {
            // Icon bên trái (Nếu có iconName thì load ảnh, tạm thời để placeholder)
            RoundedRectangle(cornerRadius: 16)
                .fill(Color(hex: lesson.iconColor).opacity(0.2)) // Hàm hex extension bên dưới
                .frame(width: 64, height: 64)
                .overlay(
                    // Dùng SF Symbols cho iconName
                    Image(systemName: UIImage(systemName: lesson.iconName) != nil ? lesson.iconName : "questionmark.square.dashed")
                        .foregroundColor(Color(hex: lesson.iconColor))
                        .font(.title2)
                )

            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(lesson.subject.uppercased())
                        .font(.caption.bold())
                        .foregroundColor(.blue)

                    Text(lesson.grade.uppercased())
                        .font(.caption.bold())
                        .foregroundColor(.gray)
                }
                
                // Sửa: Dùng lesson.name thay vì lesson.title
                Text(lesson.name)
                    .font(.system(size: 16, weight: .semibold))
                    .lineLimit(2)
            }
            Spacer()

            VStack(spacing: 14) {
                NavigationLink(destination: EditLesson(lesson: lesson)) {
                                    Image(systemName: "pencil")
                                        .foregroundColor(.blue)
                                }
                Button {
                    lessonToDelete = lesson
                    showDeleteAlert = true
                } label: {
                    Image(systemName: "trash").foregroundColor(.red)
                }
            }
        }
        .padding()
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .shadow(color: .black.opacity(0.05), radius: 6, x: 0, y: 4)
    }
}

// Helper để convert chuỗi mã màu Hex (ví dụ "#FF0000") sang Color
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
