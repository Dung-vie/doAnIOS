//
//  UserCreateQuestionView.swift
//  appHocTap
//
//  Created by  User on 22.12.2025.
//

import SwiftUI

struct UserCreateQuestionView: View {
    @State private var newQuestion = Question(
            content: "",
            answers: [
                Answer(content: ""),
                Answer(content: ""),
                Answer(content: ""),
                Answer(content: "")
            ],
            correctAnswerIndex: 0
        )
        @Environment(\.dismiss) private var dismiss
        
        var body: some View {
            NavigationStack {
                VStack {
                    Form {
                        Section("Nội dung câu hỏi") {
                            TextField("Nhập nội dung câu hỏi tại đây...",
                                      text: $newQuestion.content,
                                      axis: .vertical)
                                .lineLimit(3...6)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                        
                        Section("Các đáp án") {
                            ForEach(0..<newQuestion.answers.count, id: \.self) { index in
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Đáp án \(["A", "B", "C", "D"][index])")
                                        .font(.caption)
                                        .foregroundColor(.gray)
                                    
                                    TextField("Nhập đáp án \(["A", "B", "C", "D"][index])",
                                              text: $newQuestion.answers[index].content)
                                        .textFieldStyle(RoundedBorderTextFieldStyle())
                                }
                                .padding(.vertical, 4)
                            }
                        }
                        
                        Section("Chọn đáp án đúng") {
                            HStack(spacing: 20) {
                                ForEach(0..<4) { index in
                                    AnswerButtonView(
                                        letter: ["A", "B", "C", "D"][index],
                                        isSelected: newQuestion.correctAnswerIndex == index
                                    ) {
                                        newQuestion.correctAnswerIndex = index
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical)
                        }
                    }
                    
                    Spacer()
                    
                    HStack {
                        Button("Hủy") {
                            dismiss()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                        .foregroundColor(.black)
                        
                        Button("Lưu Câu Hỏi") {
                            print("Câu hỏi mới: \(newQuestion)")
                            dismiss()
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(newQuestion.content.isEmpty || newQuestion.answers.contains { $0.content.isEmpty } ? Color.gray : Color.green)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                    }
                    .padding()
                }
                .navigationTitle("Thêm Câu Hỏi Mới")
                .navigationBarTitleDisplayMode(.inline)
            }
        }

    struct AnswerButtonView: View {
        var letter: String
        var isSelected: Bool
        var action: () -> Void
        
        var body: some View {
            Button(action: action) {
                Text(letter)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(isSelected ? Color.green : Color.gray.opacity(0.2))
                    .cornerRadius(10)
                    .font(.title2)
            }
        }
    }
}

//struct UserCreateQuestionView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserCreateQuestionView()
//    }
//}
