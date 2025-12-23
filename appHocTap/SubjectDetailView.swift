//
//  SubjectDetailView.swift
//  appHocTap
//
//  Created by User on 15.12.2025.
//

import SwiftUI

struct SubjectDetailView: View {

    @Environment(\.dismiss) private var dismiss
    
    let subjectName: String
    let gradeName: String
    
    @State private var lessons: [LessonModel] = []
    @State private var isLoading = true

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {

                // Header
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.black)
                    }
                    Spacer()
                    Text("\(subjectName) - \(gradeName)")
                        .font(.system(size: 20, weight: .bold))
                    Spacer()
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                // List Bài học
                VStack(spacing: 14) {
                    if isLoading {
                        ProgressView("Đang tải bài học...").padding(.top, 40)
                    } else if lessons.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "books.vertical")
                                .font(.system(size: 50))
                                .foregroundColor(.gray.opacity(0.5))
                            Text("Chưa có bài học nào.").foregroundColor(.gray)
                        }
                        .padding(.top, 60)
                    } else {
                        ForEach(lessons) { lesson in
                            NavigationLink {
                                // Truyền lesson thật vào màn hình làm bài
                                QuizQuestionScreen(lesson: lesson)
                            } label: {
                                LessonCard(lesson: lesson)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)
                Spacer(minLength: 20)
            }
            .padding(.bottom, 24)
        }
        .background(Color(white: 0.96).ignoresSafeArea())
        .navigationBarHidden(true)
        .onAppear {
            loadRealLessons()
        }
    }
    
    func loadRealLessons() {
        LessonController.shared.fetchAllLessons { allLessons in
            DispatchQueue.main.async {
                // Lọc bài học: Cả tên Môn và tên Lớp phải trùng khớp
                self.lessons = allLessons.filter {
                    $0.subject == self.subjectName && $0.grade == self.gradeName
                }
                self.isLoading = false
            }
        }
    }
}

private struct LessonCard: View {
    let lesson: LessonModel
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(Color(hex: lesson.iconColor).opacity(0.15))
                    .frame(width: 52, height: 52)
                Image(systemName: UIImage(systemName: lesson.iconName) != nil ? lesson.iconName : "book.fill")
                    .font(.title3.weight(.semibold))
                    .foregroundColor(Color(hex: lesson.iconColor))
            }
            VStack(alignment: .leading, spacing: 6) {
                Text(lesson.name).font(.system(size: 17, weight: .semibold)).foregroundColor(.black).lineLimit(2)
                Text(lesson.description).font(.system(size: 15, weight: .medium)).foregroundColor(.gray).lineLimit(1)
            }
            Spacer()
            Image(systemName: "chevron.right").foregroundColor(.gray.opacity(0.7))
        }
        .padding(.horizontal, 16).padding(.vertical, 18)
        .background(Color.white).clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
    }
}
