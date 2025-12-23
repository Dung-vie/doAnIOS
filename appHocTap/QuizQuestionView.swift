//
//  QuizQuestionView.swift
//  appHocTap
//
//  Created by User on 16.12.2025.
//

import SwiftUI

struct QuizQuestionScreen: View {
    // --- 1. NHẬN DỮ LIỆU BÀI HỌC ---
    let lesson: LessonModel
    @Environment(\.dismiss) private var dismiss
    
    // --- 2. CÁC BIẾN TRẠNG THÁI (STATE) ---
    @State private var questions: [Question] = []
    @State private var currentQuestionIndex = 0
    @State private var isLoading = true
    @State private var showScoreAlert = false // Hiện điểm khi làm xong hết
    @State private var score = 0
    
    // Lưu trạng thái chọn của từng câu hỏi (Key: Index câu hỏi, Value: Index đáp án đã chọn)
    @State private var userSelections: [Int: Int] = [:]
    // Lưu trạng thái đã nộp bài của từng câu hỏi
    @State private var submittedQuestions: Set<Int> = []

    // Màu xanh chủ đạo
    let primaryGreen = Color(red: 0.0, green: 0.85, blue: 0.45)
    
    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
            
            if isLoading {
                ProgressView("Đang tải câu hỏi...")
            } else if questions.isEmpty {
                // Trường hợp không có câu hỏi
                VStack {
                    Image(systemName: "doc.text.magnifyingglass")
                        .font(.system(size: 50)).foregroundColor(.gray)
                    Text("Bài học này chưa có câu hỏi nào.").foregroundColor(.gray).padding()
                    Button("Quay lại") { dismiss() }
                }
            } else {
                // --- GIAO DIỆN CHÍNH ---
                VStack(spacing: 0) {
                    
                    // --- HEADER ---
                    HStack {
                        Button(action: { dismiss() }) {
                            Image(systemName: "arrow.left")
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundColor(.black)
                        }
                        Spacer()
                        Text(lesson.name) // Hiển thị tên bài học thật
                            .font(.headline).fontWeight(.bold).foregroundColor(.black).lineLimit(1)
                        Spacer()
                        Image(systemName: "arrow.left").font(.system(size: 20)).opacity(0)
                    }
                    .padding()
                    .background(Color.white)
                    
                    // --- NỘI DUNG CUỘN ---
                    ScrollView {
                        VStack(spacing: 24) {
                            
                            // 1. Thông tin tiến độ
                            VStack(alignment: .leading, spacing: 10) {
                                HStack {
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text("Câu \(currentQuestionIndex + 1)/\(questions.count)")
                                            .font(.headline).fontWeight(.bold)
                                    }
                                    Spacer()
                                    HStack(spacing: 6) {
                                        Image(systemName: "infinity").font(.system(size: 14))
                                        Text("Không giới hạn thời gian").font(.caption).fontWeight(.medium)
                                    }
                                    .padding(.vertical, 8).padding(.horizontal, 12)
                                    .background(Color.white).cornerRadius(20)
                                    .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                                }
                                
                                // Progress Bar động
                                GeometryReader { geo in
                                    ZStack(alignment: .leading) {
                                        Rectangle().fill(Color.gray.opacity(0.2)).frame(height: 6).cornerRadius(3)
                                        Rectangle().fill(primaryGreen)
                                            .frame(width: geo.size.width * CGFloat(currentQuestionIndex + 1) / CGFloat(questions.count), height: 6)
                                            .cornerRadius(3)
                                            .animation(.spring(), value: currentQuestionIndex)
                                    }
                                }
                                .frame(height: 6)
                            }
                            .padding(.horizontal).padding(.top, 10)
                            
                            // 2. Thẻ Câu hỏi (Dữ liệu thật)
                            let currentQuestion = questions[currentQuestionIndex]
                            
                            Text(currentQuestion.content)
                                .font(.system(size: 18, weight: .semibold))
                                .lineSpacing(4)
                                .foregroundColor(.black)
                                .padding(20)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .background(Color.white).cornerRadius(20)
                                .padding(.horizontal)
                                .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                            
                            // 3. Danh sách Đáp án (Dữ liệu thật)
                            VStack(spacing: 16) {
                                ForEach(Array(currentQuestion.answers.enumerated()), id: \.offset) { index, answer in
                                    Button {
                                        // Chỉ cho chọn nếu chưa nộp bài câu này
                                        if !submittedQuestions.contains(currentQuestionIndex) {
                                            userSelections[currentQuestionIndex] = index
                                        }
                                    } label: {
                                        // Xác định trạng thái để tô màu
                                        let isSelected = userSelections[currentQuestionIndex] == index
                                        let isSubmitted = submittedQuestions.contains(currentQuestionIndex)
                                        let isCorrectAnswer = index == currentQuestion.correctAnswerIndex
                                        
                                        OptionRowReal(
                                            text: ["A. ", "B. ", "C. ", "D. "][index] + answer.content,
                                            isSelected: isSelected,
                                            isSubmitted: isSubmitted,
                                            isCorrectAnswer: isCorrectAnswer,
                                            primaryColor: primaryGreen
                                        )
                                    }
                                    .buttonStyle(PlainButtonStyle())
                                }
                            }
                            .padding(.horizontal)
                        }
                        .padding(.bottom, 100)
                    }
                }
                
                // --- FOOTER ---
                VStack {
                    Spacer()
                    VStack(spacing: 16) {
                        // Hàng nút Trước - Sau
                        HStack(spacing: 16) {
                            Button(action: {
                                if currentQuestionIndex > 0 { currentQuestionIndex -= 1 }
                            }) {
                                HStack {
                                    Image(systemName: "chevron.left")
                                    Text("Câu Trước")
                                }
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(currentQuestionIndex > 0 ? .black : .gray)
                                .frame(maxWidth: .infinity).padding(.vertical, 14)
                                .background(Color.white).cornerRadius(30)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                            }
                            .disabled(currentQuestionIndex == 0)
                            
                            Button(action: {
                                if currentQuestionIndex < questions.count - 1 { currentQuestionIndex += 1 }
                            }) {
                                HStack {
                                    Text("Câu Sau")
                                    Image(systemName: "chevron.right")
                                }
                                .font(.system(size: 16, weight: .bold))
                                .foregroundColor(currentQuestionIndex < questions.count - 1 ? .black : .gray)
                                .frame(maxWidth: .infinity).padding(.vertical, 14)
                                .background(Color.white).cornerRadius(30)
                                .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                            }
                            .disabled(currentQuestionIndex == questions.count - 1)
                        }
                        
                        // Nút Nộp bài / Kiểm tra
                        let isSubmitted = submittedQuestions.contains(currentQuestionIndex)
                        Button(action: {
                            checkAnswer()
                        }) {
                            Text(isSubmitted ? "Đã trả lời" : "Kiểm tra đáp án")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundColor(isSubmitted ? .gray : .black)
                                .frame(maxWidth: .infinity).padding(.vertical, 16)
                                .background(isSubmitted ? Color.gray.opacity(0.2) : primaryGreen)
                                .cornerRadius(30)
                                .shadow(color: primaryGreen.opacity(0.3), radius: 5, x: 0, y: 4)
                        }
                        .disabled(isSubmitted || userSelections[currentQuestionIndex] == nil)
                    }
                    .padding(20)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [Color(UIColor.systemGray6).opacity(0), Color(UIColor.systemGray6)]), startPoint: .top, endPoint: .bottom)
                            .padding(.top, -30)
                    )
                }
            }
        }
        .onAppear {
            loadQuestions()
        }
        .alert("Chúc mừng!", isPresented: $showScoreAlert) {
            Button("Thoát", role: .cancel) { dismiss() }
        } message: {
            Text("Bạn đã hoàn thành bài tập.\nĐiểm số: \(score)/\(questions.count)")
        }
    }
    
    // --- LOGIC XỬ LÝ ---
    
    func loadQuestions() {
        QuestionController.shared.fetchQuestions(forLessonId: lesson.id) { loadedQuestions in
            DispatchQueue.main.async {
                self.questions = loadedQuestions
                self.isLoading = false
            }
        }
    }
    
    func checkAnswer() {
        // Đánh dấu câu hiện tại là đã nộp
        submittedQuestions.insert(currentQuestionIndex)
        
        // Tính điểm
        let currentQ = questions[currentQuestionIndex]
        if let selectedIndex = userSelections[currentQuestionIndex],
           selectedIndex == currentQ.correctAnswerIndex {
            score += 1
        }
        
        // Nếu là câu cuối cùng thì hiện bảng điểm
        if submittedQuestions.count == questions.count {
            showScoreAlert = true
        }
    }
}

// Component con: Một dòng đáp án (Có logic đổi màu)
struct OptionRowReal: View {
    var text: String
    var isSelected: Bool
    var isSubmitted: Bool
    var isCorrectAnswer: Bool // Đây có phải là đáp án đúng của câu hỏi không?
    var primaryColor: Color
    
    var body: some View {
        // Logic màu sắc
        var borderColor: Color {
            if isSubmitted {
                if isCorrectAnswer { return .green } // Đáp án đúng luôn hiện xanh
                if isSelected && !isCorrectAnswer { return .red } // Chọn sai hiện đỏ
                return .clear
            }
            return isSelected ? primaryColor : .clear
        }
        
        var iconName: String? {
            if isSubmitted {
                if isCorrectAnswer { return "checkmark.circle.fill" }
                if isSelected && !isCorrectAnswer { return "xmark.circle.fill" }
            }
            return nil
        }
        
        return HStack {
            Text(text)
                .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                .foregroundColor(.black)
            
            Spacer()
            
            if let icon = iconName {
                Image(systemName: icon)
                    .foregroundColor(icon == "checkmark.circle.fill" ? .green : .red)
                    .font(.system(size: 20))
            }
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Color.white)
        .cornerRadius(16)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(borderColor, lineWidth: 2)
        )
        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
    }
}
