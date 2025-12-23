//
//  AddLesson.swift
//  appHocTap
//

import SwiftUI

struct AddLesson: View {

    @Environment(\.dismiss) private var dismiss

    // --- Các biến nhập liệu ---
    @State private var lessonName = ""
    @State private var description = ""
    
    // Mặc định chọn icon đầu tiên và màu đầu tiên để không bị rỗng
    @State private var iconName = "book.fill"
    @State private var iconColor = "#3B82F6" // Màu xanh dương mặc định

    @State private var selectedSubject = ""
    @State private var selectedGrade = ""
    
    @State private var subjectList: [SubjectModel] = []
    @State private var gradeList: [GradeModel] = []

    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // --- DANH SÁCH DỮ LIỆU MẪU ĐỂ CHỌN ---
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
                    infoSection
                    
                    // --- Phần chọn Icon và Màu mới ---
                    iconSelector
                    colorSelector
                    // --------------------------------
                    
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

    private var infoSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Thông tin bài học").font(.system(size: 24, weight: .bold))
            Text("Nhập thông tin chi tiết để tạo bài học mới.")
                .foregroundColor(.green).font(.system(size: 15, weight: .medium))

            inputField(title: "Tên bài học", placeholder: "Ví dụ: Bài 1...", text: $lessonName)

            dropdownField(title: "Môn học", placeholder: "Chọn môn học", selection: $selectedSubject, options: subjectList.map { $0.name })

            dropdownField(title: "Lớp", placeholder: "Chọn khối lớp", selection: $selectedGrade, options: gradeList.map { $0.name })

            multiLineField(title: "Mô tả bài học", placeholder: "Nhập mô tả...", text: $description)
        }
    }
    
    // --- UI CHỌN ICON ---
    private var iconSelector: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Chọn Icon")
                .font(.system(size: 16, weight: .bold))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(sampleIcons, id: \.self) { icon in
                        Button {
                            iconName = icon
                        } label: {
                            Image(systemName: icon)
                                .font(.system(size: 24))
                                .frame(width: 50, height: 50)
                                // Nếu được chọn thì đổi màu nền và màu icon
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
    
    // --- UI CHỌN MÀU ---
    private var colorSelector: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Chọn Màu sắc")
                .font(.system(size: 16, weight: .bold))
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(sampleColors, id: \.self) { colorHex in
                        Button {
                            iconColor = colorHex
                        } label: {
                            ZStack {
                                Circle()
                                    .fill(Color(hex: colorHex)) // Dùng extension Color(hex:)
                                    .frame(width: 44, height: 44)
                                
                                // Nếu được chọn thì hiện dấu tích
                                if iconColor == colorHex {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 18, weight: .bold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(2)
                            // Viền ngoài khi được chọn
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
    
    private func saveLessonAction() {
        // Validate
        if lessonName.isEmpty || selectedSubject.isEmpty || selectedGrade.isEmpty || description.isEmpty {
            alertMessage = "Vui lòng nhập đầy đủ tên, môn, lớp và mô tả!"
            showAlert = true
            return
        }
        
        // Gọi Controller
        LessonController.shared.addNewLesson(
            name: lessonName,
            description: description,
            subject: selectedSubject,
            grade: selectedGrade,
            iconName: iconName,   // Lấy từ biến @State đã chọn
            iconColor: iconColor  // Lấy từ biến @State đã chọn
        ) { success, errorMsg in
            if success {
                print("Lưu thành công!")
                dismiss()
            } else {
                alertMessage = "Lỗi khi lưu: \(errorMsg ?? "Không xác định")"
                showAlert = true
            }
        }
    }

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

// MARK: - Custom Fields
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

// Bạn cần đảm bảo đã có extension này trong dự án (nếu chưa có thì thêm vào cuối file)
/*
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
*/
