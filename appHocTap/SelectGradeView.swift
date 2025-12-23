//
//  SelectGradeView.swift
//  appHocTap
//
//  Created by User on 16.12.2025.
//

import SwiftUI

struct SelectGradeView: View {
    
    // Nhận môn học từ HomeView
    let selectedSubject: SubjectModel
    
    @State private var grades: [GradeModel] = []
    
    var body: some View {
        VStack(spacing: 24) {
            // Header
            VStack(spacing: 8) {
                Text("Môn \(selectedSubject.name)")
                    .font(.system(size: 24, weight: .bold))
                    .foregroundColor(selectedSubject.iconColor)
                
                Text("Bé muốn học kiến thức lớp mấy?")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            .padding(.top, 16)
            
            // List Lớp
            ScrollView {
                VStack(spacing: 16) {
                    if grades.isEmpty {
                        ProgressView("Đang tải danh sách lớp...")
                            .padding(.top, 20)
                    } else {
                        ForEach(grades) { grade in
                            // --- CHUYỂN SANG DANH SÁCH BÀI HỌC ---
                            NavigationLink {
                                SubjectDetailView(
                                    subjectName: selectedSubject.name,
                                    gradeName: grade.name
                                )
                            } label: {
                                GradeRow(
                                    title: grade.name,
                                    icon: grade.icon,
                                    bgColor: grade.color,
                                    iconColor: grade.iconColor
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
        .onAppear {
            loadRealData()
        }
    }
    
    func loadRealData() {
        GradeController.shared.fetchGrades { loadedGrades in
            DispatchQueue.main.async { self.grades = loadedGrades }
        }
    }
}
