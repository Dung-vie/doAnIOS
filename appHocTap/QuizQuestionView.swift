//
//  QuizQuestionView.swift
//  appHocTap
//
//  Created by  User on 16.12.2025.
//

import SwiftUI

struct QuizQuestionScreen: View {
    // Màu xanh chủ đạo (lấy mã màu gần giống trong ảnh)
    let primaryGreen = Color(red: 0.0, green: 0.85, blue: 0.45)
    
    var body: some View {
        ZStack {
            // 1. Nền tổng thể màu xám nhạt
            Color(UIColor.systemGray6)
                .edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 0) {
                // --- HEADER (Thanh tiêu đề) ---
                HStack {
                    Button(action: {}) {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                    }
                    
                    Spacer()
                    
                    Text("Câu Hỏi")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                    
                    Spacer()
                    
                    // Spacer ẩn để cân đối tiêu đề vào giữa
                    Image(systemName: "arrow.left")
                        .font(.system(size: 20))
                        .opacity(0)
                }
                .padding()
                .background(Color.white) // Nền trắng cho header
                
                // --- NỘI DUNG CHÍNH (Cuộn được) ---
                ScrollView {
                    VStack(spacing: 24) {
                        
                        // 1. Phần Thông tin tiến độ (Câu 2/10 & Thời gian)
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Câu 2/10")
                                        .font(.headline)
                                        .fontWeight(.bold)
                                }
                                
                                Spacer()
                                
                                // Huy hiệu thời gian
                                HStack(spacing: 6) {
                                    Image(systemName: "infinity") // Icon vô cực
                                        .font(.system(size: 14))
                                    Text("Không giới hạn thời gian")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }
                            
                            // Thanh Progress Bar
                            ZStack(alignment: .leading) {
                                Rectangle() // Nền xám
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(height: 6)
                                    .cornerRadius(3)
                                
                                Rectangle() // Phần xanh (20%)
                                    .fill(primaryGreen)
                                    .frame(width: 80, height: 6) // Chiều dài tĩnh
                                    .cornerRadius(3)
                            }
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)
                        
                        // 2. Thẻ Câu hỏi
                        Text("Hành tinh nào trong hệ mặt trời của chúng ta được biết đến với tên gọi \"Hành tinh Đỏ\"?")
                            .font(.system(size: 18, weight: .semibold))
                            .lineSpacing(4)
                            .foregroundColor(.black)
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.horizontal)
                            .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)
                        
                        // 3. Danh sách Đáp án
                        VStack(spacing: 16) {
                            // Đáp án A (Thường)
                            OptionRowStatic(text: "A. Trái Đất", isSelected: false, primaryColor: primaryGreen)
                            
                            // Đáp án B (Đang chọn - Màu xanh)
                            OptionRowStatic(text: "B. Sao Hỏa", isSelected: true, primaryColor: primaryGreen)
                            
                            // Đáp án C (Thường)
                            OptionRowStatic(text: "C. Sao Mộc", isSelected: false, primaryColor: primaryGreen)
                            
                            // Đáp án D (Thường)
                            OptionRowStatic(text: "D. Sao Thổ", isSelected: false, primaryColor: primaryGreen)
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 100) // Để nội dung không bị che bởi footer
                }
            }
            
            // --- FOOTER (Nút điều hướng cố định ở đáy) ---
            VStack {
                Spacer()
                
                VStack(spacing: 16) {
                    // Hàng nút Trước - Sau
                    HStack(spacing: 16) {
                        Button(action: {}) {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Câu Trước")
                            }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(30)
                            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                        }
                        
                        Button(action: {}) {
                            HStack {
                                Text("Câu Sau")
                                Image(systemName: "chevron.right")
                            }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(30)
                            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                        }
                    }
                    
                    // Nút Nộp bài
                    Button(action: {}) {
                        Text("Nộp bài")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black) // Chữ màu đen như ảnh (hoặc trắng tùy ý)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(primaryGreen)
                            .cornerRadius(30)
                            .shadow(color: primaryGreen.opacity(0.3), radius: 5, x: 0, y: 4)
                    }
                }
                .padding(20)
                .background(
                    // Hiệu ứng mờ dần nền trắng ở chân trang
                    LinearGradient(gradient: Gradient(colors: [Color(UIColor.systemGray6).opacity(0), Color(UIColor.systemGray6)]), startPoint: .top, endPoint: .bottom)
                        .padding(.top, -30)
                )
            }
        }
    }
}

// Component con: Một dòng đáp án
struct OptionRowStatic: View {
    var text: String
    var isSelected: Bool
    var primaryColor: Color
    
    var body: some View {
        HStack {
            Text(text)
                .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                .foregroundColor(.black)
            
            Spacer()
        }
        .padding(.vertical, 16)
        .padding(.horizontal, 20)
        .background(Color.white) // Luôn nền trắng
        .cornerRadius(16)
        // Viền xanh nếu được chọn
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? primaryColor : Color.clear, lineWidth: 2)
        )
        // Shadow nhẹ
        .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
    }
}

//struct QuizQuestionView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuizQuestionView()
//    }
//}
