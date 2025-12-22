import Foundation
import SwiftUI

struct AddQuestionView: View {
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
        NavigationView {
            VStack {
                // Phần nội dung câu hỏi và các đáp án
                Form {
                    // Phần Nội dung câu hỏi
                    Section("Nội dung câu hỏi") {
                        TextField("Nhập nội dung câu hỏi tại đây...",
                                  text: $newQuestion.content, axis: .vertical)
                            .lineLimit(3...6)
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                    }
                    
                    // Phần Các đáp án
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
                    
                    // Phần Chọn đáp án đúng
                    Section("Chọn đáp án đúng") {
                        HStack(spacing: 20) {
                            ForEach(0..<4) { index in
                                AnswerButton(
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
                
                Spacer() // Đẩy các nút xuống dưới cùng

                // Phần các nút Hủy và Lưu Câu Hỏi
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
                        // TODO: Lưu câu hỏi vào database
                        print("Câu hỏi mới: \(newQuestion)")
                        dismiss()
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(newQuestion.content.isEmpty || newQuestion.answers.contains { $0.content.isEmpty } ? Color.gray : Color(red: 76/255, green: 175/255, blue: 80/255))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                }
                .padding()
            }
            .navigationTitle("Thêm Câu Hỏi Mới")
            .navigationBarTitleDisplayMode(.inline)
        }
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
                .background(isSelected ? Color(red: 52/255, green: 199/255, blue: 89/255) : Color.gray.opacity(0.2))
                .cornerRadius(10)
                .font(.title2)
        }
    }
}
