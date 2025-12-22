//
//  EditQuestionView.swift
//  appHocTap
//
//  Created by  User on 16.12.2025.
//

import Foundation
import SwiftUI

struct EditQuestionView: View {
    @Binding var question: Question
    @State private var tempQuestion: Question
    @Environment(\.dismiss) private var dismiss
    
    init(question: Binding<Question>) {
        self._question = question
        self._tempQuestion = State(initialValue: question.wrappedValue)
    }
    
    var body: some View {
        NavigationView {
            Form {
                // Phần Nội dung câu hỏi
                Section("Nội dung câu hỏi") {
                    TextEditor(text: $tempQuestion.content)
                        .frame(height: 100)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )
                }
                
                // Phần Các đáp án
                Section("Các đáp án") {
                    ForEach(0..<tempQuestion.answers.count, id: \.self) { index in
                        HStack {
                            TextField("Đáp án \(["A", "B", "C", "D"][index])",
                                    text: $tempQuestion.answers[index].content)
                            
                            // Nút radio cho đáp án đúng
                            RadioButton(isSelected: tempQuestion.correctAnswerIndex == index) {
                                tempQuestion.correctAnswerIndex = index
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                // Phần Chọn đáp án đúng với các nút lớn
                Section("Chọn đáp án đúng") {
                    HStack(spacing: 20) {
                        ForEach(0..<4) { index in
                            AnswerButton(
                                letter: ["A", "B", "C", "D"][index],
                                isSelected: tempQuestion.correctAnswerIndex == index
                            ) {
                                tempQuestion.correctAnswerIndex = index
                            }
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                }
            }
            .navigationTitle("Sửa Câu Hỏi")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Hủy") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Lưu Thay Đổi") {
                        question = tempQuestion
                        dismiss()
                    }
                    .bold()
                    .disabled(tempQuestion.content.isEmpty || tempQuestion.answers.contains { $0.content.isEmpty })
                }
            }
        }
    }
}

// Component Radio Button
struct RadioButton: View {
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Circle()
                .stroke(isSelected ? Color.blue : Color.gray, lineWidth: 2)
                .frame(width: 24, height: 24)
                .overlay(
                    Circle()
                        .fill(isSelected ? Color.blue : Color.clear)
                        .frame(width: 12, height: 12)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

// Component Answer Button lớn
struct AnswerButton: View {
    let letter: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(letter)
                .font(.title2)
                .fontWeight(.bold)
                .frame(width: 50, height: 50)
                .background(isSelected ? Color.blue : Color.gray.opacity(0.2))
                .foregroundColor(isSelected ? .white : .primary)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(isSelected ? Color.blue : Color.clear, lineWidth: 3)
                )
        }
    }
}
