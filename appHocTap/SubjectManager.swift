//
//  SubjectManager.swift
//  appHocTap
//
//  Created by User on 22.12.2025.
//

import SwiftUI

struct SubjectManager: View {
    
    // --- 1. THAY ĐỔI: Biến chứa dữ liệu thật ---
    @State private var subjects: [SubjectModel] = []
    @Environment(\.dismiss) private var dismiss
    // ------------------------------------------
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(UIColor.systemGray6)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(spacing: 16) {
                        
                        // Kiểm tra nếu chưa có dữ liệu
                        if subjects.isEmpty {
                            Text("Đang tải dữ liệu...")
                                .foregroundColor(.gray)
                                .padding(.top, 40)
                        } else {
                            // --- 2. THAY ĐỔI: Duyệt qua danh sách thật ---
                            ForEach(subjects) { subject in
                                SubjectCard(subject: subject)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 40)
                }
            }
            .navigationTitle("Quản Lý Môn Học")
            .navigationBarTitleDisplayMode(.large)
            
        }
        // --- 3. THAY ĐỔI: Tải dữ liệu khi vào màn hình ---
        .onAppear {
            loadRealData()
        }
    }
    
    // Hàm gọi Controller tải dữ liệu
    func loadRealData() {
        SubjectController.shared.fetchSubjects { (data, error) in
            if let realSubjects = data {
                DispatchQueue.main.async {
                    self.subjects = realSubjects
                }
            }
        }
    }
}

// MARK: - SubjectCard (Cập nhật để nhận SubjectModel thật)
struct SubjectCard: View {
    let subject: SubjectModel // Sử dụng SubjectModel thay vì SubjectItem cũ
    
    var body: some View {
        Button(action: {
            // Navigate to subject detail (Tính năng sau)
        }) {
            HStack(spacing: 16) {
                // Icon
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(subject.color) // Lấy màu nền nhạt từ Model
                        .frame(width: 80, height: 80)
                    
                    Image(systemName: subject.icon)
                        .font(.system(size: 32, weight: .semibold))
                        .foregroundColor(subject.iconColor) // Lấy màu icon đậm từ Model
                }
                
                // Text content
                VStack(alignment: .leading, spacing: 4) {
                    Text(subject.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.black)
                    
                    Text(subject.subtitle)
                        .font(.system(size: 16))
                        .foregroundColor(.gray)
                }
                
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(Color.white)
            .cornerRadius(20)
            .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Preview
//struct SubjectManagerView_Previews: PreviewProvider {
//    static var previews: some View {
//        SubjectManager()
//    }
//}
