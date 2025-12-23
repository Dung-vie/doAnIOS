//
//  AddLesson.swift
//  appHocTap
//

import SwiftUI

struct AddLesson: View {

    @Environment(\.dismiss) private var dismiss

    // Các biến nhập liệu
    @State private var lessonName = ""
    @State private var description = ""
    @State private var iconName = ""
    @State private var iconColor = ""

    // Biến lưu lựa chọn hiện tại
    @State private var selectedSubject = ""
    @State private var selectedGrade = ""
    
    // Biến dữ liệu
    @State private var subjectList: [SubjectModel] = []
    @State private var gradeList: [GradeModel] = []

    // --- 1. THÊM BIẾN ALERT ---
    @State private var showAlert = false
    @State private var alertMessage = ""
    // --------------------------

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 22) {
                    header
                    infoSection
                    saveButton
                    cancelButton
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 30)
            }
            .background(Color(white: 0.97))
            .navigationBarHidden(true)
            .onAppear {
                loadRealData()
            }
            // --- 2. THÊM MODIFIER ALERT ---
            .alert("Thông báo", isPresented: $showAlert) {
                Button("Đóng", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    func loadRealData() {
        SubjectController.shared.fetchSubjects { (subjects, _) in
            if let data = subjects {
                DispatchQueue.main.async { self.subjectList = data }
            }
        }
        GradeController.shared.fetchGrades { grades in
            DispatchQueue.main.async { self.gradeList = grades }
        }
    }
}

// MARK: - UI Components
extension AddLesson {
    
    // (Header giữ nguyên)
    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.weight(.semibold))
            }
            Spacer()
            Text("Thêm Bài Học")
                .font(.system(size: 20, weight: .bold))
            Spacer()
            Color.clear.frame(width: 24)
        }
        .padding(.top, 8)
    }

    // (InfoSection giữ nguyên như code cũ của bạn)
    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Thông tin bài học").font(.system(size: 24, weight: .bold))
            Text("Nhập thông tin chi tiết để tạo bài học mới.")
                .foregroundColor(.green).font(.system(size: 15, weight: .medium))

            inputField(title: "Tên bài học", placeholder: "Ví dụ: Bài 1...", text: $lessonName)

            dropdownField(title: "Môn học", placeholder: "Chọn môn học", selection: $selectedSubject, options: subjectList.map { $0.name })

            dropdownField(title: "Lớp", placeholder: "Chọn khối lớp", selection: $selectedGrade, options: gradeList.map { $0.name })

            multiLineField(title: "Mô tả bài học", placeholder: "Nhập mô tả...", text: $description)

            inputField(title: "Tên Icon", placeholder: "Ví dụ: book.fill", text: $iconName)
            
            inputField(title: "Mã màu Icon", placeholder: "Ví dụ: #13ec5b", text: $iconColor)
        }
    }

    // --- 3. SỬA NÚT LƯU ---
    private var saveButton: some View {
        Button {
            saveLessonAction()
        } label: {
            Text("Lưu Bài Học")
                .font(.system(size: 18, weight: .bold))
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.green)
                .foregroundColor(.black)
                .clipShape(Capsule())
        }
        .padding(.top, 10)
    }
    
    // --- 4. HÀM XỬ LÝ LƯU (Logic Validate) ---
    private func saveLessonAction() {
        // Validate: Kiểm tra xem có trường nào bị bỏ trống không
        if lessonName.isEmpty || selectedSubject.isEmpty || selectedGrade.isEmpty || description.isEmpty || iconName.isEmpty || iconColor.isEmpty {
            
            alertMessage = "Vui lòng nhập đầy đủ tất cả các trường thông tin!"
            showAlert = true
            return
        }
        
        // Gọi Controller để lưu
        LessonController.shared.addNewLesson(
            name: lessonName,
            description: description,
            subject: selectedSubject,
            grade: selectedGrade,
            iconName: iconName,
            iconColor: iconColor
        ) { success, errorMsg in
            
            if success {
                // Lưu thành công -> Đóng màn hình
                print("Lưu thành công!")
                dismiss()
            } else {
                // Lưu thất bại -> Hiện lỗi
                alertMessage = "Lỗi khi lưu: \(errorMsg ?? "Không xác định")"
                showAlert = true
            }
        }
    }

    // (CancelButton giữ nguyên)
    private var cancelButton: some View {
        Button { dismiss() } label: {
            Text("Hủy Bỏ")
                .foregroundColor(.green)
                .font(.system(size: 16, weight: .semibold))
                .frame(maxWidth: .infinity)
        }
        .padding(.top, 6)
    }
}

// (Phần Custom Fields giữ nguyên như code cũ)
extension AddLesson {
    private func inputField(title: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.system(size: 16, weight: .bold))
            TextField(placeholder, text: text)
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.green.opacity(0.25)))
        }
    }

    private func multiLineField(title: String, placeholder: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.system(size: 16, weight: .bold))
            TextEditor(text: text)
                .frame(height: 110)
                .padding(10)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.green.opacity(0.25)))
                .overlay(Group {
                    if text.wrappedValue.isEmpty {
                        Text(placeholder).foregroundColor(.gray.opacity(0.6))
                            .padding(.horizontal, 16).padding(.vertical, 14).allowsHitTesting(false)
                    }
                }, alignment: .topLeading)
        }
    }

    private func dropdownField(title: String, placeholder: String, selection: Binding<String>, options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.system(size: 16, weight: .bold))
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) { selection.wrappedValue = option }
                }
            } label: {
                HStack {
                    Text(selection.wrappedValue.isEmpty ? placeholder : selection.wrappedValue)
                        .foregroundColor(selection.wrappedValue.isEmpty ? .gray : .black)
                    Spacer()
                    Image(systemName: "chevron.down").foregroundColor(.green)
                }
                .padding()
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: 18))
                .overlay(RoundedRectangle(cornerRadius: 18).stroke(Color.green.opacity(0.25)))
            }
        }
    }
}
