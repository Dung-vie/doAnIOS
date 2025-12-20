//
//  ConfirmationModal.swift
//  appHocTap
//
//  Created by  User on 16.12.2025.
//

import SwiftUI

struct ConfirmationModal: View {
    // Màu xanh chủ đạo
    let primaryGreen = Color(red: 0.0, green: 0.85, blue: 0.45)
    
    var body: some View {
        ZStack {
            // 1. NỀN TỐI (Dimmed Background)
            Color.black.opacity(0.4)
                .edgesIgnoringSafeArea(.all) // Tràn toàn màn hình
            
            // 2. MODAL (Thẻ thông báo)
            VStack(spacing: 20) {
                // --- Icon Dấu hỏi ---
                ZStack {
                    Circle()
                        .fill(primaryGreen.opacity(0.2)) // Nền xanh nhạt
                        .frame(width: 70, height: 70)
                    
                    Image(systemName: "questionmark")
                        .font(.system(size: 30, weight: .bold))
                        .foregroundColor(primaryGreen)
                }
                .padding(.top, 10)
                
                // --- Tiêu đề & Nội dung ---
                Text("Bạn chắc chứ?")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("Bạn chưa hoàn thành tất cả các câu\nhỏi. Bạn có chắc chắn muốn nộp bài\nkhông?")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true) // Để text tự xuống dòng
                    .padding(.horizontal, 10)
                
                // --- Các nút bấm (Buttons) ---
                VStack(spacing: 12) {
                    // Nút 1: Tiếp tục làm bài (Màu xanh)
                    Button(action: {}) {
                        Text("Tiếp tục làm bài")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white) // Chữ trắng
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(primaryGreen)
                            .cornerRadius(30)
                    }
                    
                    // Nút 2: Nộp bài (Màu xám)
                    Button(action: {}) {
                        Text("Nộp bài")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black) // Chữ đen
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(UIColor.systemGray6)) // Xám nhạt
                            .cornerRadius(30)
                    }
                }
                .padding(.top, 10)
                
            }
            .padding(30) // Padding bên trong modal
            .background(Color.white)
            .cornerRadius(24)
            .shadow(radius: 20) // Đổ bóng cho nổi
            .padding(.horizontal, 40) // Khoảng cách với mép màn hình
        }
    }
}

//struct ConfirmationModal_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmationModal()
//    }
//}
