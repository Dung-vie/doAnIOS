//
//  ManagerView.swift
//  appHocTap
//
//  Created by User on 15.12.2025.
//

import SwiftUI

struct ManagerView: View {
    
    // --- 1. BIẾN LƯU SỐ LƯỢNG CÂU HỎI THẬT ---
    @State private var totalQuestionsCount: Int = 0
    // -----------------------------------------
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Header
                    HStack {
                        Text("Trang Chủ Quản Trị")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        // --- 2. SỬA LINK VỀ HOMEVIEW ---
                        NavigationLink {
                            HomeView() // Chuyển đến trang chủ người dùng
                        } label: {
                            Image(systemName: "house.fill")
                                .font(.title2)
                        }
                        // -------------------------------
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Statistic Cards
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Tổng số người dùng",
                            value: "1,234" // Giả lập (chưa có API user)
                        )
                        
                        // --- 3. HIỂN THỊ SỐ LƯỢNG THẬT ---
                        StatCard(
                            title: "Tổng số câu hỏi",
                            value: "\(totalQuestionsCount)" // Hiển thị biến @State
                        )
                        // ---------------------------------
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Section Title
                    Text("Điều hướng chính")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    // MARK: - Navigation Buttons
                    VStack(spacing: 16) {
                        
                        // --- Hàng 1: Câu hỏi & Người dùng ---
                        HStack(spacing: 16) {
                            NavigationLink {
                                QuestionListView()
                            } label: {
                                AdminActionCard(
                                    icon: "questionmark.square",
                                    title: "Quản lý Câu hỏi",
                                    subtitle: "Tạo, sửa, xóa câu hỏi"
                                )
                            }
                            
                            NavigationLink {
                                UserListView()
                            } label: {
                                AdminActionCard(
                                    icon: "person.2.fill",
                                    title: "Quản lý Người dùng",
                                    subtitle: "Xem và quản lý tài khoản"
                                )
                            }
                        }
                        
                        // --- Hàng 2: Bài học & Lớp học ---
                        HStack(spacing: 16) {
                            NavigationLink {
                                LessonManager()
                            } label: {
                                AdminActionCard(
                                    icon: "book.fill",
                                    title: "Quản lý Bài học",
                                    subtitle: "Soạn thảo nội dung bài"
                                )
                            }
                            
                            NavigationLink {
                                ClassManager()
                            } label: {
                                AdminActionCard(
                                    icon: "graduationcap.fill",
                                    title: "Quản lý Lớp học",
                                    subtitle: "Phân cấp chương trình"
                                )
                            }
                        }
                        
                        // --- Hàng 3: Môn học (Thêm cho đủ bộ) ---
                        HStack(spacing: 16) {
                            NavigationLink {
                                SubjectManager()
                            } label: {
                                AdminActionCard(
                                    icon: "books.vertical.fill",
                                    title: "Quản lý Môn học",
                                    subtitle: "Toán, Văn, Anh..."
                                )
                            }
                            Spacer() // Để canh trái nếu hàng này chỉ có 1 nút
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarHidden(true)
            // --- 4. TẢI DỮ LIỆU KHI VÀO MÀN HÌNH ---
            .onAppear {
                loadStats()
            }
        }
    }
    
    // Hàm tải thống kê
    func loadStats() {
        // Gọi QuestionController để lấy danh sách câu hỏi -> đếm số lượng
        QuestionController.shared.fetchQuestions { questions in
            DispatchQueue.main.async {
                self.totalQuestionsCount = questions.count
            }
        }
    }
}

// Preview
struct ManagerView_Previews: PreviewProvider {
    static var previews: some View {
        ManagerView()
    }
}
