//
//  ResultScreen.swift
//  appHocTap
//
//  Created by User on 16.12.2025.
//

import SwiftUI

struct ResultScreen: View {
    // --- 1. BIẾN NHẬN DỮ LIỆU TỪ BÊN NGOÀI ---
    var score: Int                  // Số câu đúng (VD: 7)
    var totalQuestions: Int         // Tổng số câu (VD: 10)
    var wrongAnswers: [String]      // Danh sách các câu sai (để lưu lại)
    
    // Biến môi trường để đóng màn hình (quay về trang trước)
    @Environment(\.presentationMode) var presentationMode

    // Màu sắc giao diện
    let primaryGreen = Color(red: 0.0, green: 0.85, blue: 0.45)
    let primaryRed = Color(red: 1.0, green: 0.4, blue: 0.4)
    
    var body: some View {
        ZStack {
            // Nền tổng thể
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                // --- HEADER ---
                HStack {
                    Button(action: {
                        // Đóng màn hình khi bấm X
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Text("Kết quả bài quiz")
                        .font(.headline)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    // Spacer ẩn để cân bằng
                    Image(systemName: "xmark").hidden()
                }
                .padding()
                
                // --- 2. ĐIỂM SỐ (HIỂN THỊ DỮ LIỆU THẬT) ---
                VStack(spacing: 8) {
                    // Hiển thị điểm số dựa trên biến score và totalQuestions
                    Text("Bạn đúng \(score)/\(totalQuestions) câu")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(.black)
                    
                    // Logic hiển thị lời khen (Trên 50% thì khen, dưới thì động viên)
                    Text(Double(score) / Double(totalQuestions) >= 0.5 ? "Làm tốt lắm!" : "Cố gắng lần sau nhé!")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                }
                .padding(.vertical, 20)
                
                // --- 3. DANH SÁCH ĐÁP ÁN (Scroll View) ---
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Xem lại đáp án")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        // LƯU Ý CHO NHÓM:
                        // Phần hiển thị chi tiết từng câu hỏi dưới đây đang là DỮ LIỆU MẪU (Hardcode).
                        // Để hiển thị đúng bài vừa làm, bạn Dung cần truyền danh sách câu hỏi vào đây
                        // và dùng vòng lặp ForEach.
                        VStack(spacing: 12) {
                            
                            AnswerRow(
                                title: "Câu 1: Thủ đô của Việt...",
                                userChoice: "Hà Nội",
                                isCorrect: true,
                                primaryGreen: primaryGreen,
                                primaryRed: primaryRed
                            )
                            
                            AnswerRow(
                                title: "Câu 2: Đâu là hành tinh lớn...",
                                userChoice: "Trái Đất",
                                correctChoice: "Sao Mộc",
                                isCorrect: false,
                                primaryGreen: primaryGreen,
                                primaryRed: primaryRed
                            )
                            
                            AnswerRow(
                                title: "Câu 3: 2 + 2 bằng mấy?",
                                userChoice: "4",
                                isCorrect: true,
                                primaryGreen: primaryGreen,
                                primaryRed: primaryRed
                            )
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                }
                
                // --- 4. FOOTER (Nút bấm) ---
                VStack(spacing: 12) {
                    // Nút Làm lại
                    Button(action: {
                        // Logic làm lại bài (Reset game) sẽ do bạn Dung xử lý
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Làm lại")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(primaryGreen)
                            .cornerRadius(30)
                    }
                    
                    // Nút Về Home
                    Button(action: {
                        // Đóng màn hình kết quả để về trang trước
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("Về Home")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(primaryGreen.opacity(0.25))
                            .cornerRadius(30)
                    }
                }
                .padding(20)
            }
        }
        // --- 5. QUAN TRỌNG: TỰ ĐỘNG LƯU KẾT QUẢ ---
        // Khi màn hình hiện ra (.onAppear), gọi Manager để lưu xuống máy ngay lập tức
        .onAppear {
            MyDatabase.shared.saveQuizResult(
        score: score,
        total: totalQuestions,
        wrongAnswers: [] // Truyền list câu sai của bạn vào đây
    ) { success in
        if success {
            print("✅ Đã lưu lên Firebase")
        } else {
            print("❌ Lưu thất bại")
        }
    }
        }
    }
}

// --- COMPONENT CON: Dòng hiển thị đáp án (Giữ nguyên) ---
struct AnswerRow: View {
    let title: String
    let userChoice: String
    var correctChoice: String? = nil // Chỉ cần khi sai
    let isCorrect: Bool
    let primaryGreen: Color
    let primaryRed: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // 1. Icon Trạng thái
            ZStack {
                Circle()
                    .fill(isCorrect ? primaryGreen.opacity(0.15) : primaryRed.opacity(0.15))
                    .frame(width: 40, height: 40)
                
                Image(systemName: isCorrect ? "checkmark" : "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isCorrect ? primaryGreen : primaryRed)
            }
            
            // 2. Nội dung Text
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)
                
                Text("Bạn đã chọn: \(userChoice)")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
                
                if !isCorrect, let correct = correctChoice {
                    Text("Đáp án đúng: \(correct)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(primaryGreen)
                }
            }
            
            Spacer()
            
            // 3. Chữ Đúng/Sai
            Text(isCorrect ? "Đúng" : "Sai")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isCorrect ? primaryGreen : primaryRed)
                .padding(.top, 4)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}