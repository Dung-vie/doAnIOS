//
//  HomeView.swift
//  appHocTap
//
//  Created by User on 15.12.2025.
//

import SwiftUI

struct HomeView: View {

    enum Tab {
        case profile
        case time
    }

    @State private var selectedTab: Tab = .profile
    @State private var subjects: [SubjectModel] = []
    private let subjectController = SubjectController.shared

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Header
                    HStack {
                        Image(systemName: "graduationcap.fill")
                            .foregroundColor(.green)
                            .font(.title2)
                        Spacer()
                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person.fill")
                                .foregroundColor(.black)
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    Text("Quiz Học Tập")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.horizontal, 20)

                    Text("Chọn Môn Học")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.horizontal, 20)

                    // Grid Môn Học
                    if subjects.isEmpty {
                        Text("Đang tải dữ liệu...")
                            .foregroundColor(.gray)
                            .padding(.leading, 20)
                    } else {
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            ForEach(subjects) { subject in
                                // --- CHUYỂN SANG CHỌN LỚP ---
                                NavigationLink(destination: SelectGradeView(selectedSubject: subject)) {
                                    subjectCard(
                                        icon: subject.icon,
                                        bgColor: subject.color,
                                        title: subject.name,
                                        subtitle: subject.subtitle,
                                        iconColor: subject.iconColor
                                    )
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                loadSubjects()
            }
        }
    }
    
    func loadSubjects() {
        SubjectController.shared.fetchSubjects { (dsMonHoc, _) in
            if let data = dsMonHoc {
                DispatchQueue.main.async { self.subjects = data }
            }
        }
    }

    // (Các helper function giữ nguyên)
    private func subjectCard(icon: String, bgColor: Color, title: String, subtitle: String, iconColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 20).fill(bgColor).frame(height: 140)
                Image(systemName: icon).font(.system(size: 40)).foregroundColor(iconColor)
            }
            Text(title).font(.headline)
            Text(subtitle).font(.subheadline).foregroundColor(.gray)
        }
    }
}	
