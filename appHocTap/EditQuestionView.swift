//
//  EditQuestionView.swift
//  appHocTap
//

import SwiftUI

struct EditQuestionView: View {
    @Environment(\.dismiss) private var dismiss
    
    // Dữ liệu câu hỏi cần sửa
    var question: Question
    
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
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    var filteredLessons: [LessonModel] {
        return allLessons.filter { lesson in
            let matchSubject = selectedSubject.isEmpty || lesson.subject == selectedSubject
            let matchGrade = selectedGrade.isEmpty || lesson.grade == selectedGrade
            return matchSubject && matchGrade
        }
    }
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                headerView
                
                ScrollView {
                   
                        // Row 1: Môn & Lớp
                        // Row 1: Môn trên – Lớp dưới
                        VStack(alignment: .leading, spacing: 16) {
                            
                            
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Môn học")
                                    .font(.system(size: 16, weight: .semibold))
                                
                                Menu {
                                    ForEach(subjectList.map{$0.name}, id: \.self) { option in
                                        Button(option) {
                                            selectedSubject = option
                                            selectedLessonId = ""
                                            selectedLessonName = ""
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text(selectedSubject.isEmpty ? "Chọn môn" : selectedSubject)
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
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 0)      // ❗ Không bo góc
                                            .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                                    )
                                }
                            
                            
                            // Lớp học (giữ như cũ – bo góc tròn)
                            dropdownSection(
                                title: "Lớp học",
                                placeholder: "Chọn lớp",
                                selection: $selectedGrade,
                                options: gradeList.map { $0.name }
                            )
                        }

                        
                        // Row 2: Bài học
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Bài học").font(.system(size: 16, weight: .semibold))
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
                        
                        // Nội dung
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Nội dung câu hỏi").font(.system(size: 16, weight: .semibold))
                            TextEditor(text: $questionContent)
                                .frame(height: 120).padding(4)
                                .background(Color.white).cornerRadius(12)
                                .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.gray.opacity(0.2), lineWidth: 1))
                                .scrollContentBackground(.hidden)
                        }
                        
                        // Đáp án
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Các đáp án").font(.system(size: 16, weight: .bold))
                            answerTextField(title: "Đáp án A", text: $answerA)
                            answerTextField(title: "Đáp án B", text: $answerB)
                            answerTextField(title: "Đáp án C", text: $answerC)
                            answerTextField(title: "Đáp án D", text: $answerD)
                        }
                        
                        // Chọn đúng
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Chọn đáp án đúng").font(.system(size: 16, weight: .bold))
                            HStack(spacing: 12) {
                                ForEach(0..<4, id: \.self) { index in
                                    let letters = ["A", "B", "C", "D"]
                                    Button { correctAnswerIndex = index } label: {
                                        Text(letters[index])
                                            .font(.system(size: 16, weight: .bold))
                                            .frame(maxWidth: .infinity).frame(height: 50)
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
                    .padding(.horizontal, 20).padding(.top, 20)
                }
                
                // Bottom Buttons
                VStack {
                    Divider()
                    HStack(spacing: 16) {
                        Button { dismiss() } label: {
                            Text("Hủy").font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity).frame(height: 50)
                                .background(Color(hex: "#E8EAF0")).foregroundColor(.black).cornerRadius(25)
                        }
                        Button { saveChanges() } label: {
                            Text("Lưu Thay Đổi").font(.system(size: 16, weight: .bold))
                                .frame(maxWidth: .infinity).frame(height: 50)
                                .background(Color(hex: "#13ec5b")).foregroundColor(.white).cornerRadius(25)
                        }
                    }
                    .padding(20)
                }
                .background(Color.white)
            }
            .background(Color.white)
            .navigationBarHidden(true)
            .onAppear {
                loadInitialData()
            }
            .alert("Thông báo", isPresented: $showAlert) {
                Button("Đóng", role: .cancel) { }
            } message: { Text(alertMessage) }
        }
    }
    
    // MARK: - Logic
    func loadInitialData() {
        // 1. Load lists
        SubjectController.shared.fetchSubjects { data, _ in if let d = data { DispatchQueue.main.async { self.subjectList = d } } }
        GradeController.shared.fetchGrades { data in DispatchQueue.main.async { self.gradeList = data } }
        LessonController.shared.fetchAllLessons { lessons in
            DispatchQueue.main.async {
                self.allLessons = lessons
                // 2. Sau khi có danh sách bài học, điền dữ liệu cũ vào Form
                self.fillOldData()
            }
        }
    }
    
    func fillOldData() {
        questionContent = question.content
        correctAnswerIndex = question.correctAnswerIndex
        selectedLessonId = question.lessonId
        
        if question.answers.count >= 4 {
            answerA = question.answers[0].content
            answerB = question.answers[1].content
            answerC = question.answers[2].content
            answerD = question.answers[3].content
        }
        
        // Tìm bài học cũ để điền tên Môn, Lớp, Bài
        if let oldLesson = allLessons.first(where: { $0.id == selectedLessonId }) {
            selectedLessonName = oldLesson.name
            selectedSubject = oldLesson.subject
            selectedGrade = oldLesson.grade
        }
    }
    
    func saveChanges() {
        guard !questionContent.isEmpty, !selectedLessonId.isEmpty, !answerA.isEmpty else {
            alertMessage = "Vui lòng nhập đầy đủ thông tin"
            showAlert = true
            return
        }
        
        // Tạo object mới nhưng GIỮ ID CŨ
        let updatedQ = Question(
            id: question.id, // <--- Quan trọng: ID cũ
            content: questionContent,
            answers: [
                Answer(content: answerA), Answer(content: answerB),
                Answer(content: answerC), Answer(content: answerD)
            ],
            correctAnswerIndex: correctAnswerIndex,
            lessonId: selectedLessonId
        )
        
        QuestionController.shared.updateQuestion(updatedQ) { success in
            if success {
                print("Cập nhật thành công")
                dismiss()
            } else {
                alertMessage = "Lỗi khi cập nhật"
                showAlert = true
            }
        }
    }
    
    // MARK: - UI Helpers (Copy từ AddQuestionView sang cho nhanh)
    var headerView: some View {
        HStack {
            Button { dismiss() } label: { Image(systemName: "chevron.left").font(.title3.weight(.bold)).foregroundColor(.black) }
            Spacer()
            Text("Sửa Câu Hỏi").font(.system(size: 20, weight: .bold))
            Spacer()
            Image(systemName: "chevron.left").font(.title3.weight(.bold)).foregroundColor(.clear)
        }.padding(.horizontal, 20).padding(.top, 10).padding(.bottom, 10)
    }
    
    @ViewBuilder
    func dropdownSection(title: String, placeholder: String, selection: Binding<String>, options: [String]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.system(size: 16, weight: .semibold))
            Menu {
                ForEach(options, id: \.self) { option in
                    Button(option) { selection.wrappedValue = option; selectedLessonId = ""; selectedLessonName = "" }
                }
            } label: { dropdownLabel(text: selection.wrappedValue.isEmpty ? placeholder : selection.wrappedValue) }
        }
    }
    
    @ViewBuilder
    func dropdownLabel(text: String) -> some View {
        HStack {
            Text(text).font(.system(size: 15)).foregroundColor(.black).lineLimit(1)
            Spacer()
            Image(systemName: "chevron.down").font(.system(size: 12)).foregroundColor(.gray)
        }
        .padding(.horizontal, 16).frame(height: 50).background(Color.white).cornerRadius(25)
        .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.gray.opacity(0.2), lineWidth: 1))
    }
    
    @ViewBuilder
    func answerTextField(title: String, text: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title).font(.system(size: 15, weight: .medium))
            TextField("Nhập \(title.lowercased())", text: text)
                .padding(.horizontal, 16).frame(height: 50).background(Color.white).cornerRadius(25)
                .overlay(RoundedRectangle(cornerRadius: 25).stroke(Color.gray.opacity(0.2), lineWidth: 1))
        }
    }
}
