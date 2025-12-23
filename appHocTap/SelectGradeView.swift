//
//  SelectGradeView.swift
//  appHocTap
//
//  Created by User on 16.12.2025.
//

import SwiftUI

struct SelectGradeView: View {
    
    // --- 1. Biến chứa danh sách lớp thật ---
    @State private var grades: [GradeModel] = []
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                
                // MARK: - Header
                VStack(spacing: 8) {
                    Text("Bé học lớp mấy?")
                        .font(.system(size: 24, weight: .bold))
                    
                    Text("Hãy chọn lớp để bắt đầu bài học nhé!")
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                .padding(.top, 16)
                
                // MARK: - Grade List (Dữ liệu thật)
                ScrollView {
                    VStack(spacing: 16) {
                        
                        // Kiểm tra nếu đang tải hoặc không có dữ liệu
                        if grades.isEmpty {
                            ProgressView("Đang tải dữ liệu...")
                                .padding(.top, 20)
                        } else {
                            // --- 2. Duyệt qua danh sách thật ---
                            ForEach(grades) { grade in
                                NavigationLink {
                                    HomeView() // Chuyển đến trang chủ
                                } label: {
                                    GradeRow(
                                        title: grade.name,
                                        icon: grade.icon,
                                        bgColor: grade.color,      // Màu nền nhạt (từ Model)
                                        iconColor: grade.iconColor // Màu icon đậm (từ Model)
                                    )
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                }
                
                Spacer()
            }
            .padding(.horizontal, 24)
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            // --- 3. Gọi hàm tải dữ liệu khi màn hình hiện lên ---
            .onAppear {
                loadRealData()
            }
        }
    }
    
    // Hàm tải dữ liệu từ Firebase
    func loadRealData() {
        GradeController.shared.fetchGrades { loadedGrades in
            DispatchQueue.main.async {
                self.grades = loadedGrades
            }
        }
    }
}

struct SelectGradeView_Previews: PreviewProvider {
    static var previews: some View {
        SelectGradeView()
    }
}
