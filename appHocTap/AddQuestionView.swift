import SwiftUI

struct AddQuestionView: View {
    @Environment(\.dismiss) private var dismiss
    
    // MARK: - Data State
    @State private var subjectList: [SubjectModel] = []
    @State private var gradeList: [GradeModel] = []
    @State private var allLessons: [LessonModel] = []
    
    // MARK: - Selection State
    @State private var selectedSubject: String = ""
    @State private var selectedGrade: String = ""
    @State private var selectedLessonId: String = ""
    @State private var selectedLessonName: String = ""
    
    // MARK: - Question Data State
    @State private var questionContent: String = ""
    @State private var answerA: String = ""
    @State private var answerB: String = ""
    @State private var answerC: String = ""
    @State private var answerD: String = ""
    @State private var correctAnswerIndex: Int = 0
    
    // MARK: - Alert State (THÊM BIẾN NÀY)
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Logic lọc bài học
    var filteredLessons: [LessonModel] {
        return allLessons.filter { lesson in
            let matchSubject = selectedSubject.isEmpty || lesson.subject == selectedSubject
            let matchGrade = selectedGrade.isEmpty || lesson.grade == selectedGrade
            return matchSubject && matchGrade
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                headerView
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        
                        // MARK: - Row 1: Môn & Lớp
                        HStack(spacing: 12) {
                            dropdownSection(title: "Môn học", placeholder: "Chọn môn", selection: $selectedSubject, options: subjectList.map { $0.name })
                            dropdownSection(title: "Lớp học", placeholder: "Chọn lớp", selection: $selectedGrade, options: gradeList.map { $0.name })
                        }
                        
                        // MARK: - Row 2: Bài học
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bài học")
                                .font(.system(size: 16, weight: .semibold))
                            
                            Menu {
                                if filteredLessons.isEmpty {
                                    Text("Không có bài học phù hợp")
                                } else {
                                    ForEach(filteredLessons) { lesson in
                                        Button(lesson.name) {
                                            selectedLessonName = lesson.name
                                            selectedLessonId = lesson.id
                                        }
                                    }
                                }
                            } label: {
                                dropdownLabel(text: selectedLessonName.isEmpty ? "Chọn bài học" : selectedLessonName)
                            }
                        }
                        
                        // MARK: - Nội dung câu hỏi
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nội dung câu hỏi")
                                .font(.system(size: 16, weight: .semibold))
                            
                            ZStack(alignment: .topLeading) {
                                if questionContent.isEmpty {
                                    Text("Nhập nội dung câu hỏi tại đây...")
                                        .foregroundColor(Color(UIColor.placeholderText))
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 16)
                                }
                                TextEditor(text: $questionContent)
                                    .frame(height: 120)
                                    .padding(4)
                                    .background(Color.clear)
                                    .scrollContentBackground(.hidden)
                            }
                            .background(Color.white)
                            .cornerRadius(12)
                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                        }
                        
                        // MARK: - Các đáp án
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Các đáp án")
                                .font(.system(size: 16, weight: .bold))
                            
                            answerTextField(title: "Đáp án A", text: $answerA)
                            answerTextField(title: "Đáp án B", text: $answerB)
                            answerTextField(title: "Đáp án C", text: $answerC)
                            answerTextField(title: "Đáp án D", text: $answerD)
                        }
                        
                        // MARK: - Chọn đáp án đúng
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Chọn đáp án đúng")
                                .font(.system(size: 16, weight: .bold))
                            
                            HStack(spacing: 12) {
                                ForEach(0..<4, id: \.self) { index in
                                    let letters = ["A", "B", "C", "D"]
                                    Button {
                                        correctAnswerIndex = index
                                    } label: {
                                        Text(letters[index])
                                            .font(.system(size: 16, weight: .bold))
                                            .frame(maxWidth: .infinity)
                                            .frame(height: 50)
                                            .background(correctAnswerIndex == index ? Color(hex: "#DCE4F9") : Color(hex: "#E8EAF0"))
                                            .foregroundColor(correctAnswerIndex == index ? .blue : .black)
                                            .cornerRadius(12)
                                            .overlay(RoundedRectangle(cornerRadius: 12).stroke(correctAnswerIndex == index ? Color.blue : Color.clear, lineWidth: 1.5))
                                    }
                                }
                            }
                        }
                        Spacer(minLength: 20)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                }
                
                // MARK: - Bottom Actions
                VStack {
                    Divider()
                    HStack(spacing: 16) {
                        Button { dismiss() } label: {
                            Text("Hủy")
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color(hex: "#E8EAF0"))
                                .foregroundColor(.black)
                                .cornerRadius(25)
                        }
                        
                        Button {
                            saveQuestion()
                        } label: {
                            Text("Lưu Câu Hỏi")
                                .font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .background(Color(hex: "#13ec5b"))
                                .foregroundColor(.white)
                                .cornerRadius(25)
                        }
                    }
                    .padding(20)
                }
                .background(Color.white)
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .onAppear { loadInitialData() }
            // --- THÊM ALERT ---
            .alert("Thông báo", isPresented: $showAlert) {
                Button("Đóng", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
        }
    }
    
    // MARK: - Logic Functions
    func loadInitialData() {
        SubjectController.shared.fetchSubjects { (subjects, _) in
            if let data = subjects { DispatchQueue.main.async { self.subjectList = data } }
        }
        GradeController.shared.fetchGrades { grades in
            DispatchQueue.main.async { self.gradeList = grades }
        }
        LessonController.shared.fetchAllLessons { lessons in
            DispatchQueue.main.async { self.allLessons = lessons }
        }
    }
    
    // --- HÀM LƯU CÂU HỎI MỚI ---
    func saveQuestion() {
        // 1. Validate: Kiểm tra dữ liệu rỗng
        if selectedLessonId.isEmpty {
            alertMessage = "Vui lòng chọn Bài học!"
            showAlert = true
            return
        }
        
        if questionContent.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            alertMessage = "Vui lòng nhập nội dung câu hỏi!"
            showAlert = true
            return
        }
        
        if answerA.isEmpty || answerB.isEmpty || answerC.isEmpty || answerD.isEmpty {
            alertMessage = "Vui lòng nhập đầy đủ 4 đáp án!"
            showAlert = true
            return
        }
        
        // 2. Gọi Controller để lưu
        QuestionController.shared.addQuestion(
            content: questionContent,
            answerA: answerA,
            answerB: answerB,
            answerC: answerC,
            answerD: answerD,
            correctAnswerIndex: correctAnswerIndex,
            lessonId: selectedLessonId
        ) { success, error in
            
            if success {
                print("Đã lưu câu hỏi thành công!")
                DispatchQueue.main.async {
                    dismiss() // Đóng màn hình
                }
            } else {
                alertMessage = "Lỗi khi lưu: \(error ?? "Không xác định")"
                showAlert = true
            }
        }
    }
}

// MARK: - UI Helper Components
extension AddQuestionView {
    
    var headerView: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.weight(.bold))
                    .foregroundColor(.black)
            }
            
            Spacer()
            
            Text("Thêm Câu Hỏi Mới")
                .font(.system(size: 20, weight: .bold))
            
            Spacer()
            
            // Dummy view để cân bằng layout title
            Image(systemName: "chevron.left")
                .font(.title3.weight(.bold))
                .foregroundColor(.clear)
        }
        .padding(.horizontal, 20)
        .padding(.top, 10)
        .padding(.bottom, 10)
    }
    
    @ViewBuilder
    func dropdownSection(title: String, placeholder: String, selection: Binding<String>, options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 16, weight: .semibold))
            
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) {
                        selection.wrappedValue = option
                        // Reset bài học khi đổi môn/lớp
                        selectedLessonId = ""
                        selectedLessonName = ""
                    }
                }
            } label: {
                dropdownLabel(text: selection.wrappedValue.isEmpty ? placeholder : selection.wrappedValue)
            }
        }
    }
    
    @ViewBuilder
    func dropdownLabel(text: String) -> some View {
        HStack {
            Text(text)
                .font(.system(size: 15))
                .foregroundColor(.black)
                .lineLimit(1)
            Spacer()
            Image(systemName: "chevron.down")
                .font(.system(size: 12))
                .foregroundColor(.gray)
        }
        .padding(.horizontal, 16)
        .frame(height: 50)
        .background(Color.white)
        .cornerRadius(25) // Bo tròn như ảnh
        .overlay(
            RoundedRectangle(cornerRadius: 25)
                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
        )
    }
    
    @ViewBuilder
    func answerTextField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.system(size: 15, weight: .medium))
            
            TextField("Nhập \(title.lowercased())", text: text)
                .padding(.horizontal, 16)
                .frame(height: 50)
                .background(Color.white)
                .cornerRadius(25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                )
        }
    }
}

// Preview
struct AddQuestionView_Previews: PreviewProvider {
    static var previews: some View {
        AddQuestionView()
    }
}
