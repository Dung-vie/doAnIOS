//
//  QuestionListView.swift
//  appHocTap
//
//  Created by  User on 15.12.2025.
//

import SwiftUI

struct QuestionListView: View {
    var body: some View {
        NavigationStack {
                    VStack {
                        // Filter
                        HStack {
                            FilterChip(title: "Toán")
                            FilterChip(title: "Lớp 1")
                            Spacer()
                        }
                        .padding()

                        // List
                        ScrollView {
                            VStack(spacing: 12) {
                                QuestionRow(
                                    title: "Câu 1: Phép cộng trong phạm vi 10",
                                    answers: ["A. 5", "B. 6", "C. 7", "D. 8"]
                                )

                                QuestionRow(
                                    title: "Câu 2: 3 + 4 bằng mấy?",
                                    answers: ["A. 5", "B. 6", "C. 7", "D. 8"]
                                )
                            }
                            .padding()
                        }

                        // Add button
                        Button {
                            // sau này gắn Firebase
                        } label: {
                            Image(systemName: "plus")
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.green)
                                .clipShape(Circle())
                        }
                        .padding()
                    }
                    .navigationTitle("Quản lý Câu hỏi")
                }

    }
}

//struct QuestionListView_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionListView()
//    }
//}
