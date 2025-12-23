//
//  ClassManager.swift
//  appHocTap
//

import SwiftUI

struct ClassManager: View {

    @Environment(\.dismiss) private var dismiss
    
    // 1. Thêm biến chứa dữ liệu tải từ Firebase
    @State private var grades: [GradeModel] = []

    var body: some View {
        ScrollView {
            VStack(spacing: 28) {

                header
                subtitle
                classList // View này sẽ tự hiển thị dữ liệu trong biến grades
                
                Spacer(minLength: 20)
            }
            .padding(.horizontal, 24)
            .padding(.top, 12)
        }
        .background(Color(white: 0.97))
        .navigationBarHidden(true)
        // 2. Tải dữ liệu khi màn hình xuất hiện
        .onAppear {
            loadData()
        }
    }
    
    // Hàm gọi Controller lấy dữ liệu
    private func loadData() {
        GradeController.shared.fetchGrades { loadedGrades in
            DispatchQueue.main.async {
                self.grades = loadedGrades
            }
        }
    }
}

// MARK: - Header
extension ClassManager {

    private var header: some View {
        HStack {
            Button { dismiss() } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.black)
            }

            Spacer()

            Text("Quản lý Lớp Học")
                .font(.system(size: 20, weight: .bold))

            Spacer()

            Color.clear.frame(width: 24)
        }
    }

    private var subtitle: some View {
        Text("Danh sách các lớp học trong hệ thống")
            .font(.system(size: 16))
            .foregroundColor(.gray)
            .padding(.top, 6)
    }
}

// MARK: - Class List 
extension ClassManager {

    private var classList: some View {
        VStack(spacing: 18) {
            
            // Kiểm tra nếu chưa có dữ liệu thì hiện Loading
            if grades.isEmpty {
                ProgressView("Đang tải danh sách...")
                    .padding()
            } else {
                // 3. Dùng ForEach duyệt qua mảng grades thật
                ForEach(grades) { grade in
                    GradeRow(
                        title: grade.name,
                        icon: grade.icon,
                        // bgColor: Lấy màu chính giảm độ đậm xuống 35%
                        bgColor: grade.color.opacity(0.35),
                        // iconColor: Lấy đúng màu chính
                        iconColor: grade.color
                    )
                }
            }
        }
        .padding(.top, 10)
    }
}
