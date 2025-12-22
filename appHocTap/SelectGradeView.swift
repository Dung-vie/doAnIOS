//
//  SelectGradeView.swift
//  appHocTap
//
//  Created by  User on 16.12.2025.
//

import SwiftUI

struct SelectGradeView: View {
    var body: some View {
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

                // MARK: - Grade List
                VStack(spacing: 16) {
                    NavigationLink {
                        HomeView()
                    } label: {
                        GradeRow(
                            title: "Lớp 1",
                            icon: "pencil",
                            bgColor: Color.orange.opacity(0.35),
                            iconColor: .orange
                        )
                    }
                    GradeRow(
                        title: "Lớp 2",
                        icon: "paintpalette.fill",
                        bgColor: Color.yellow.opacity(0.35),
                        iconColor: .yellow
                    )

                    GradeRow(
                        title: "Lớp 3",
                        icon: "book.fill",
                        bgColor: Color.green.opacity(0.35),
                        iconColor: .green
                    )

                    GradeRow(
                        title: "Lớp 4",
                        icon: "globe",
                        bgColor: Color.cyan.opacity(0.35),
                        iconColor: .cyan
                    )

                    GradeRow(
                        title: "Lớp 5",
                        icon: "paperplane.fill",
                        bgColor: Color.purple.opacity(0.35),
                        iconColor: .purple
                    )
                }

                Spacer()
            }
            .padding(.horizontal, 24)
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
        }
    }

//struct SelectGradeView_Previews: PreviewProvider {
//    static var previews: some View {
//        SelectGradeView()
//    }
//}
