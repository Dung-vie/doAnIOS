//
//  QuestionListView.swift
//  appHocTap
//

import SwiftUI

struct QuestionListView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    // --- State cho Filter ---
    @State private var selectedSubject = "Tất cả"
    @State private var selectedGrade = "Tất cả"
    @State private var selectedLessonName = "Tất cả" // Dùng tên để hiển thị trên nút
    @State private var selectedLessonId = ""         // Dùng ID để lọc chính xác
    
    // --- State Dữ liệu ---
    @State private var subjectList: [SubjectModel] = []
    @State private var gradeList: [GradeModel] = []
    @State private var lessonList: [LessonModel] = []
    @State private var allQuestions: [Question] = [] // Danh sách gốc tải từ Firebase
    
    // --- State cho Alert Xóa ---
    @State private var showDeleteAlert = false
    @State private var questionToDelete: Question?
    
    // --- LOGIC LỌC DỮ LIỆU ---
        var filteredQuestions: [Question] {
            // Debug: In ra số lượng để kiểm tra
            print("Tổng câu hỏi tải về: \(allQuestions.count)")
            print("Tổng bài học tải về: \(lessonList.count)")

            // 1. Nếu chọn "Tất cả" mọi thứ -> Hiển thị hết (Bỏ qua kiểm tra ID bài học)
            if selectedSubject == "Tất cả" && selectedGrade == "Tất cả" && selectedLessonName == "Tất cả" {
                return allQuestions
            }

            // 2. Logic lọc bình thường khi người dùng bắt đầu chọn Filter
            
            // Lọc bài học hợp lệ theo Môn/Lớp
            let validLessons = lessonList.filter { lesson in
                let matchSubject = selectedSubject == "Tất cả" || lesson.subject == selectedSubject
                let matchGrade = selectedGrade == "Tất cả" || lesson.grade == selectedGrade
                return matchSubject && matchGrade
            }
            
            let validLessonIDs = validLessons.map { $0.id }
            
            // Lọc câu hỏi
            return allQuestions.filter { question in
                // Nếu đã chọn Bài cụ thể -> Phải khớp ID bài đó
                if selectedLessonId != "" {
                    return question.lessonId == selectedLessonId
                }
                
                // Nếu chưa chọn Bài cụ thể -> Câu hỏi phải thuộc các bài trong Môn/Lớp đã chọn
                // (Nếu danh sách bài học rỗng do chưa tải xong, tạm thời vẫn cho hiện câu hỏi để debug)
                if validLessonIDs.isEmpty {
                    return true
                }
                
                return validLessonIDs.contains(question.lessonId)
            }
        }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Filter Section (Giữ nguyên UI của bạn)
                VStack(alignment: .leading, spacing: 12) {
                    // Header Filter Titles
                    HStack(spacing: 20) {
                        Text("Môn học").font(.system(size: 16, weight: .medium)).frame(width: 80, alignment: .leading)
                        Text("Lớp").font(.system(size: 16, weight: .medium)).frame(width: 80, alignment: .leading)
                        Text("Bài").font(.system(size: 16, weight: .medium)).frame(maxWidth: .infinity, alignment: .leading)
                    }
                    .padding(.horizontal, 20).padding(.top, 20)
                    
                    HStack(spacing: 12) {
                        // 1. Dropdown Môn
                        Menu {
                            Button("Tất cả") { selectedSubject = "Tất cả"; resetLessonFilter() }
                            ForEach(subjectList) { subject in
                                Button(subject.name) { selectedSubject = subject.name; resetLessonFilter() }
                            }
                        } label: { filterButtonLabel(text: selectedSubject, width: nil) }
                        
                        // 2. Dropdown Lớp
                        Menu {
                            Button("Tất cả") { selectedGrade = "Tất cả"; resetLessonFilter() }
                            ForEach(gradeList) { grade in
                                Button(grade.name) { selectedGrade = grade.name; resetLessonFilter() }
                            }
                        } label: { filterButtonLabel(text: selectedGrade, width: nil) }
                        
                        // 3. Dropdown Bài (Chỉ hiện bài thuộc Môn/Lớp đã chọn)
                        Menu {
                            Button("Tất cả") {
                                selectedLessonName = "Tất cả"
                                selectedLessonId = ""
                            }
                            // Lọc danh sách bài học để hiển thị trong Menu
                            let lessonsToShow = lessonList.filter { lesson in
                                (selectedSubject == "Tất cả" || lesson.subject == selectedSubject) &&
                                (selectedGrade == "Tất cả" || lesson.grade == selectedGrade)
                            }
                            
                            ForEach(lessonsToShow) { lesson in
                                Button(lesson.name) {
                                    selectedLessonName = lesson.name
                                    selectedLessonId = lesson.id
                                }
                            }
                        } label: {
                            filterButtonLabel(text: truncateString(selectedLessonName, length: 15), width: nil)
                        }
                    }
                    .padding(.horizontal, 20).padding(.bottom, 20)
                }
                .background(Color(UIColor.systemGray6))
                
                // --- LIST CÂU HỎI THẬT ---
                ScrollView {
                    VStack(spacing: 16) {
                        if filteredQuestions.isEmpty {
                            Text("Chưa có câu hỏi nào.")
                                .foregroundColor(.gray)
                                .padding(.top, 40)
                        } else {
                            // Duyệt qua danh sách đã lọc
                            ForEach(Array(filteredQuestions.enumerated()), id: \.element.id) { index, question in
                                QuestionCard(
                                    questionNumber: index + 1, // Số thứ tự tăng dần
                                    question: question,        // Truyền cả object Question
                                    onDelete: {
                                        // Kích hoạt Alert xóa
                                        questionToDelete = question
                                        showDeleteAlert = true
                                    }
                                )
                            }
                        }
                        Spacer().frame(height: 80)
                    }
                    .padding(.top, 20)
                }
            }
            .navigationTitle("Quản lý Câu Hỏi")
            .navigationBarTitleDisplayMode(.inline)
            .overlay(
                // Floating Add Button
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        NavigationLink(destination: AddQuestionView()) {
                            Image(systemName: "plus")
                                .font(.system(size: 24, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(width: 56, height: 56)
                                .background(Color.green)
                                .clipShape(Circle())
                                .shadow(color: .black.opacity(0.3), radius: 8, x: 0, y: 4)
                        }
                        .padding(.trailing, 20).padding(.bottom, 20)
                    }
                }
            )
            // --- ALERT XÓA ---
            .alert("Xóa câu hỏi?", isPresented: $showDeleteAlert, presenting: questionToDelete) { question in
                Button("Xóa", role: .destructive) {
                    deleteQuestionReal(id: question.id)
                }
                Button("Hủy", role: .cancel) {}
            } message: { _ in
                Text("Bạn có chắc muốn xóa câu hỏi này không? Hành động này không thể hoàn tác.")
            }
        }
        .onAppear {
            loadAllData()
        }
    }
    
    // MARK: - Functions
    
    func resetLessonFilter() {
        selectedLessonName = "Tất cả"
        selectedLessonId = ""
    }
    
    func loadAllData() {
        // Load Subject, Grade, Lesson (Giống bài trước)
        SubjectController.shared.fetchSubjects { (data, _) in if let d = data { DispatchQueue.main.async { self.subjectList = d } } }
        GradeController.shared.fetchGrades { data in DispatchQueue.main.async { self.gradeList = data } }
        LessonController.shared.fetchAllLessons { data in DispatchQueue.main.async { self.lessonList = data } }
        
        // Load Questions
        QuestionController.shared.fetchQuestions { questions in
            DispatchQueue.main.async {
                print("--- Đã tải xong câu hỏi: \(questions.count) câu ---")
                self.allQuestions = questions
            }
        }
    }
    
    // Hàm xóa câu hỏi
    func deleteQuestionReal(id: String) {
        QuestionController.shared.deleteQuestion(id: id) { success in
            if success {
                DispatchQueue.main.async {
                    // Xóa khỏi danh sách đang hiển thị
                    if let index = allQuestions.firstIndex(where: { $0.id == id }) {
                        withAnimation {
                            allQuestions.remove(at: index)
                        }
                    }
                }
            }
        }
    }
    
    func truncateString(_ str: String, length: Int) -> String {
        if str.count > length { return String(str.prefix(length)) + "..." }
        return str
    }
    
    @ViewBuilder
    func filterButtonLabel(text: String, width: CGFloat?) -> some View {
        HStack {
            Text(text).font(.system(size: 16)).foregroundColor(.black).lineLimit(1)
            Spacer()
            Image(systemName: "chevron.down").foregroundColor(.gray).font(.system(size: 14))
        }
        .padding(.horizontal, 16).padding(.vertical, 12).frame(maxWidth: width ?? .infinity)
        .background(Color.white).cornerRadius(25)
        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.gray.opacity(0.3), lineWidth: 1))
    }
}

// MARK: - QuestionCard (Cập nhật để nhận Model thật)
struct QuestionCard: View {
    let questionNumber: Int
    let question: Question // Nhận Model thật
    var onDelete: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Câu \(questionNumber): \(question.content)")
                    .font(.system(size: 16, weight: .medium))
                    .lineLimit(2)
                Spacer()
                NavigationLink(destination: EditQuestionView(question: question)) {
                    Image(systemName: "pencil")
                        .foregroundColor(.gray)
                        .font(.system(size: 18))
                }
                Button(action: onDelete) {
                    Image(systemName: "trash").foregroundColor(.red).font(.system(size: 18))
                }
            }
            .padding(.horizontal, 20)
            
            VStack(spacing: 8) {
                ForEach(Array(question.answers.enumerated()), id: \.offset) { index, answer in
                    HStack {
                        if index == question.correctAnswerIndex {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.green).font(.system(size: 20))
                        }
                        Text(answer.content).font(.system(size: 16)).foregroundColor(.black)
                        Spacer()
                    }
                    .padding(.horizontal, 20).padding(.vertical, 12)
                    .background(index == question.correctAnswerIndex ? Color.green.opacity(0.15) : Color.white)
                    .cornerRadius(12)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.1), lineWidth: 1)
                    )
                }
            }
            .padding(.horizontal, 20)
        }
        .padding(.vertical, 12)
        .background(Color.white)
        .cornerRadius(16)
        .padding(.horizontal, 20)
        .shadow(color: Color.black.opacity(0.05), radius: 5, x: 0, y: 2)
    }
}
