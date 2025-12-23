//
//  EditLesson.swift
//  appHocTap
//

import SwiftUI

struct EditLesson: View {

    @Environment(\.dismiss) private var dismiss
    
    // Dữ liệu bài học cần sửa (được truyền từ trang Manager sang)
    var lesson: LessonModel

    // MARK: - Form State
    @State private var lessonName = ""
    @State private var description = ""
    @State private var iconName = ""
    @State private var iconColor = ""

    @State private var selectedSubject = ""
    @State private var selectedGrade = ""

    // Dữ liệu dropdown từ Firebase
    @State private var subjectList: [SubjectModel] = []
    @State private var gradeList: [GradeModel] = []

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    formSection
                    actionButtons
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 28)
            }
            .background(Color(white: 0.97))
            .navigationBarHidden(true)
            .onAppear {
                // 1. Tải danh sách môn/lớp thật
                loadRealData()
                // 2. Điền dữ liệu cũ vào form
                fillData()
            }
        }
    }
    
    // Hàm điền dữ liệu cũ vào các ô input
    func fillData() {
        lessonName = lesson.name
        description = lesson.description
        selectedSubject = lesson.subject
        selectedGrade = lesson.grade
        iconName = lesson.iconName
        iconColor = lesson.iconColor
    }
    
    // Hàm tải dropdown
    func loadRealData() {
        SubjectController.shared.fetchSubjects { (subjects, _) in
            if let data = subjects { DispatchQueue.main.async { self.subjectList = data } }
        }
        GradeController.shared.fetchGrades { grades in
            DispatchQueue.main.async { self.gradeList = grades }
        }
    }
    
    // Hàm Lưu thay đổi
    func saveChanges() {
        // Tạo model mới nhưng GIỮ NGUYÊN ID CŨ
        let updatedLesson = LessonModel(
            id: lesson.id, // <--- QUAN TRỌNG: Dùng lại ID cũ
            name: lessonName,
            description: description,
            subject: selectedSubject,
            grade: selectedGrade,
            iconName: iconName,
            iconColor: iconColor
        )
        
        // Gọi Controller cập nhật
        LessonController.shared.updateLesson(updatedLesson) { success in
            if success {
                dismiss() // Đóng trang sửa
            } else {
                print("Lỗi khi cập nhật")
            }
        }
    }
}

// MARK: - Header
extension EditLesson {
    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left").font(.title3.weight(.semibold))
            }
            Spacer()
            Text("Sửa Bài Học").font(.system(size: 20, weight: .bold))
            Spacer()
            Color.clear.frame(width: 24)
        }
        .padding(.top, 8)
    }
}

// MARK: - Form
extension EditLesson {
    private var formSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            inputField(title: "Tên bài học", text: $lessonName)
            
            // Dropdown dữ liệu thật
            dropdownField(title: "Môn học", selection: $selectedSubject, options: subjectList.map { $0.name })
            dropdownField(title: "Lớp học", selection: $selectedGrade, options: gradeList.map { $0.name })
            
            multiLineField(title: "Mô tả bài học", text: $description)
            inputField(title: "Icon", text: $iconName)
            inputField(title: "Màu Icon", text: $iconColor)
        }
    }
}

// MARK: - Actions
extension EditLesson {
    private var actionButtons: some View {
        HStack(spacing: 14) {
            Button { dismiss() } label: {
                Text("Hủy")
                    .font(.system(size: 16, weight: .semibold))
                    .frame(maxWidth: .infinity).padding()
                    .background(Color.white)
                    .overlay(RoundedRectangle(cornerRadius: 30).stroke(Color.green.opacity(0.5)))
                    .clipShape(Capsule())
            }

            Button {
                saveChanges() // Gọi hàm lưu
            } label: {
                Text("Lưu Thay Đổi")
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity).padding()
                    .background(Color.green)
                    .foregroundColor(.black)
                    .clipShape(Capsule())
            }
        }
        .padding(.top, 10)
    }
}

// MARK: - Reusable Fields (Giữ nguyên UI cũ của bạn)
extension EditLesson {
    private func inputField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.system(size: 16, weight: .bold))
            TextField("", text: text).padding().background(Color.white).clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.green.opacity(0.25)))
        }
    }

    private func multiLineField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.system(size: 16, weight: .bold))
            TextEditor(text: text).frame(height: 130).padding(10).background(Color.white).clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.green.opacity(0.25)))
        }
    }

    private func dropdownField(title: String, selection: Binding<String>, options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.system(size: 16, weight: .bold))
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) { selection.wrappedValue = option }
                }
            } label: {
                HStack {
                    Text(selection.wrappedValue.isEmpty ? "Chọn..." : selection.wrappedValue).foregroundColor(.black)
                    Spacer()
                    Image(systemName: "chevron.up.chevron.down").foregroundColor(.green)
                }
                .padding().background(Color.white).clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.green.opacity(0.25)))
            }
        }
    }
}
