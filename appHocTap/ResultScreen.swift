//
//  ResultScreen.swift
//  appHocTap
//
//  Created by  User on 16.12.2025.
//

import SwiftUI

struct ResultScreen: View {
    // Màu xanh chủ đạo
    let primaryGreen = Color(red: 0.0, green: 0.85, blue: 0.45)
    // Màu đỏ cho trạng thái sai
    let primaryRed = Color(red: 1.0, green: 0.4, blue: 0.4)
    
    var body: some View {
        ZStack {
            // Nền tổng thể màu trắng hơi xám nhẹ (hoặc trắng tinh tùy ý)
            Color.white
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                
                // --- 1. HEADER ---
                HStack {
                    Button(action: {}) {
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
                
                // --- 2. ĐIỂM SỐ (Score Section) ---
                VStack(spacing: 8) {
                    Text("Bạn đúng 7/10 câu")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(.black)
                    
                    Text("Làm tốt lắm!")
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
                        
                        // Danh sách các thẻ (Cards)
                        VStack(spacing: 12) {
                            
                            // Câu 1: ĐÚNG
                            AnswerRow(
                                title: "Câu 1: Thủ đô của Việt...",
                                userChoice: "Hà Nội",
                                isCorrect: true,
                                primaryGreen: primaryGreen,
                                primaryRed: primaryRed
                            )
                            
                            // Câu 2: SAI
                            AnswerRow(
                                title: "Câu 2: Đâu là hành tinh lớn...",
                                userChoice: "Trái Đất",
                                correctChoice: "Sao Mộc", // Truyền thêm đáp án đúng nếu sai
                                isCorrect: false,
                                primaryGreen: primaryGreen,
                                primaryRed: primaryRed
                            )
                            
                            // Câu 3: ĐÚNG
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
                    // Nút Làm lại (Xanh đậm)
                    Button(action: {}) {
                        Text("Làm lại")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(primaryGreen)
                            .cornerRadius(30)
                    }
                    
                    // Nút Về Home (Xanh nhạt)
                    Button(action: {}) {
                        Text("Về Home")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(primaryGreen.opacity(0.25)) // Độ mờ để tạo màu xanh nhạt
                            .cornerRadius(30)
                    }
                }
                .padding(20)
            }
        }
    }
}

// --- COMPONENT CON: Dòng hiển thị đáp án ---
struct AnswerRow: View {
    let title: String
    let userChoice: String
    var correctChoice: String? = nil // Chỉ cần khi sai
    let isCorrect: Bool
    let primaryGreen: Color
    let primaryRed: Color
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            // 1. Icon Trạng thái (Tròn)
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
                
                // Nếu sai thì hiện thêm dòng đáp án đúng màu xanh
                if !isCorrect, let correct = correctChoice {
                    Text("Đáp án đúng: \(correct)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(primaryGreen)
                }
            }
            
            Spacer()
            
            // 3. Chữ "Đúng" / "Sai" bên phải
            Text(isCorrect ? "Đúng" : "Sai")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isCorrect ? primaryGreen : primaryRed)
                .padding(.top, 4) // Căn chỉnh cho ngang hàng với tiêu đề
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        // Hiệu ứng đổ bóng nhẹ cho thẻ
        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
        // Viền mỏng xung quanh thẻ (tùy chọn, trong ảnh có vẻ chỉ dùng shadow)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}

//struct ResultScreen_Previews: PreviewProvider {
//    static var previews: some View {
//        ResultScreen()
//    }
//}
