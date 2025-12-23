//
//  EditLesson.swift
//  appHocTap
//

import SwiftUI

struct EditLesson: View {

    @Environment(\.dismiss) private var dismiss
    
    // Dữ liệu bài học cần sửa
    var lesson: LessonModel

    // MARK: - Form State
    @State private var lessonName = ""
    @State private var description = ""
    
    // Icon và Màu (Mặc định lấy từ bài học cũ)
    @State private var iconName = ""
    @State private var iconColor = ""

    @State private var selectedSubject = ""
    @State private var selectedGrade = ""

    // Dữ liệu dropdown từ Firebase
    @State private var subjectList: [SubjectModel] = []
    @State private var gradeList: [GradeModel] = []
    
    // --- DANH SÁCH MẪU ĐỂ CHỌN ---
    let sampleIcons = [
        "book.fill", "book.closed.fill", "text.book.closed.fill",
        "pencil", "pencil.and.ruler.fill", "graduationcap.fill",
        "doc.text.fill", "note.text", "calendar",
        "globe", "flask.fill", "function", "calculator",
        "star.fill", "heart.fill", "lightbulb.fill"
    ]
    
    let sampleColors = [
        "#EF4444", // Đỏ
        "#F97316", // Cam
        "#F59E0B", // Vàng
        "#10B981", // Xanh lá
        "#3B82F6", // Xanh dương
        "#6366F1", // Chàm
        "#8B5CF6", // Tím
        "#EC4899", // Hồng
        "#6B7280"  // Xám
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    formSection
                    
                    // --- THÊM PHẦN CHỌN ICON VÀ MÀU ---
                    iconSelector
                    colorSelector
                    // ----------------------------------
                    
                    actionButtons
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 28)
            }
            .background(Color(white: 0.97))
            .navigationBarHidden(true)
            .onAppear {
                loadRealData()
                fillData()
            }
        }
    }
    
    // Hàm điền dữ liệu cũ vào các biến State
    func fillData() {
        lessonName = lesson.name
        description = lesson.description
        selectedSubject = lesson.subject
        selectedGrade = lesson.grade
        iconName = lesson.iconName
        iconColor = lesson.iconColor
    }
    
    func loadRealData() {
        SubjectController.shared.fetchSubjects { (subjects, _) in
            if let data = subjects { DispatchQueue.main.async { self.subjectList = data } }
        }
        GradeController.shared.fetchGrades { grades in
            DispatchQueue.main.async { self.gradeList = grades }
        }
    }
    
    func saveChanges() {
        let updatedLesson = LessonModel(
            id: lesson.id, // Giữ nguyên ID cũ
            name: lessonName,
            description: description,
            subject: selectedSubject,
            grade: selectedGrade,
            iconName: iconName,
            iconColor: iconColor
        )
        
        LessonController.shared.updateLesson(updatedLesson) { success in
            if success {
                dismiss()
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

// MARK: - Form Inputs
extension EditLesson {
    private var formSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            inputField(title: "Tên bài học", text: $lessonName)
            
            dropdownField(title: "Môn học", selection: $selectedSubject, options: subjectList.map { $0.name })
            dropdownField(title: "Lớp học", selection: $selectedGrade, options: gradeList.map { $0.name })
            
            multiLineField(title: "Mô tả bài học", text: $description)
        }
    }
    
    // --- UI CHỌN ICON (MỚI) ---
    private var iconSelector: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Chọn Icon").font(.system(size: 16, weight: .bold))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(sampleIcons, id: \.self) { icon in
                        Button {
                            iconName = icon
                        } label: {
                            Image(systemName: icon)
                                .font(.system(size: 24))
                                .frame(width: 50, height: 50)
                                // Highlight nếu đang được chọn
                                .background(iconName == icon ? Color.green : Color.white)
                                .foregroundColor(iconName == icon ? .white : .gray)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.green.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
    
    // --- UI CHỌN MÀU (MỚI) ---
    private var colorSelector: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Chọn Màu sắc").font(.system(size: 16, weight: .bold))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(sampleColors, id: \.self) { colorHex in
                        Button {
                            iconColor = colorHex
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: colorHex))
                                    .frame(width: 44, height: 44)
                                
                                // Dấu tích nếu đang được chọn
                                if iconColor == colorHex {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(2)
                            .overlay(
                                Circle()
                                    .stroke(iconColor == colorHex ? Color(hex: colorHex) : Color.clear, lineWidth: 2)
                            )
                        }
                    }
                }
                .padding(.vertical, 4)
            }
        }
    }
}

// MARK: - Actions & Helpers
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
                saveChanges()
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
    
    // Reusable Fields
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
