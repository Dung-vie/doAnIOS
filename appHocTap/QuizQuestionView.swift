//
//  QuizQuestionView.swift
//  appHocTap
//
//  Created by  User on 16.12.2025.
//

import SwiftUI

struct QuizQuestionScreen: View {
    @Environment(\.dismiss) private var dismiss

    let primaryGreen = Color(red: 0.0, green: 0.85, blue: 0.45)

    @StateObject private var vm: QuizController
    @State private var showResult = false

    init(bankKey: String, lessonId: String?, isUnlimited: Bool, minutes: Int) {
         _vm = StateObject(
             wrappedValue: QuizController(
                 bankKey: bankKey,
                 lessonId: lessonId,
                 isUnlimited: isUnlimited,
                 minutes: minutes
             )
         )
     }

    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).ignoresSafeArea()

            if vm.isLoading {
                ProgressView("Đang tải đề...")
            } else if let err = vm.errorMessage {
                VStack(spacing: 12) {
                    Text(err).foregroundColor(.red).multilineTextAlignment(.center)
                    Button("Thử lại") { vm.start() }
                        .padding(.horizontal, 16).padding(.vertical, 10)
                        .background(primaryGreen).cornerRadius(10)
                }
                .padding()
            } else if vm.questions.isEmpty {
                Text("Chưa có câu hỏi.")
            } else {
                content
            }
        }
        .onAppear { vm.startIfNeeded() }
        .fullScreenCover(isPresented: $showResult) {
            if let result = vm.result {
                ResultScreen(
                    result: result,
                    onRestart: {
                        showResult = false
                        vm.start()
                    },
                    onHome: {
                        showResult = false
                        dismiss()
                    }
                )
            }
        }
        .onChange(of: vm.result != nil) { hasResult in
            if hasResult { showResult = true }
        }
    }

    private var content: some View {
        let q = vm.questions[vm.currentIndex]
        let selected = vm.selectedAnswers[q.id]

        return ZStack {
            VStack(spacing: 0) {

                // Header
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "arrow.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.black)
                            .frame(width: 44, height: 44)
                    }

                    Spacer()

                    Text("Câu Hỏi")
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(.black)

                    Spacer()

                    Color.clear.frame(width: 44, height: 44)
                }
                .padding()
                .background(Color.white)

                ScrollView {
                    VStack(spacing: 24) {

                        // Progress + Time
                        VStack(alignment: .leading, spacing: 10) {
                            HStack {
                                Text(vm.progressText())
                                    .font(.headline)
                                    .fontWeight(.bold)

                                Spacer()

                                HStack(spacing: 6) {
                                    Image(systemName: vm.remainingSeconds == nil ? "infinity" : "timer")
                                        .font(.system(size: 14))
                                    Text(vm.timeBadgeText())
                                        .font(.caption)
                                        .fontWeight(.medium)
                                }
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(Color.white)
                                .cornerRadius(20)
                                .shadow(color: Color.black.opacity(0.05), radius: 2, x: 0, y: 1)
                            }

                            GeometryReader { geo in
                                ZStack(alignment: .leading) {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(height: 6)
                                        .cornerRadius(3)

                                    Rectangle()
                                        .fill(primaryGreen)
                                        .frame(width: geo.size.width * progressValue(), height: 6)
                                        .cornerRadius(3)
                                }
                            }
                            .frame(height: 6)
                        }
                        .padding(.horizontal)
                        .padding(.top, 10)

                        // Question card
                        Text(q.questionText)
                            .font(.system(size: 18, weight: .semibold))
                            .lineSpacing(4)
                            .foregroundColor(.black)
                            .padding(20)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color.white)
                            .cornerRadius(20)
                            .padding(.horizontal)
                            .shadow(color: Color.black.opacity(0.03), radius: 5, x: 0, y: 2)

                        // Options
                        VStack(spacing: 16) {
                            QuizOptionRow(
                                text: q.optionText(for: 0),
                                isSelected: selected == 0,
                                primaryColor: primaryGreen
                            ) { vm.selectAnswer(0) }

                            QuizOptionRow(
                                text: q.optionText(for: 1),
                                isSelected: selected == 1,
                                primaryColor: primaryGreen
                            ) { vm.selectAnswer(1) }

                            QuizOptionRow(
                                text: q.optionText(for: 2),
                                isSelected: selected == 2,
                                primaryColor: primaryGreen
                            ) { vm.selectAnswer(2) }

                            QuizOptionRow(
                                text: q.optionText(for: 3),
                                isSelected: selected == 3,
                                primaryColor: primaryGreen
                            ) { vm.selectAnswer(3) }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 110)
                }
            }

            // Footer
            VStack {
                Spacer()

                VStack(spacing: 16) {
                    HStack(spacing: 16) {
                        Button { vm.goPrev() } label: {
                            HStack {
                                Image(systemName: "chevron.left")
                                Text("Câu Trước")
                            }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(30)
                            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                        }
                        .disabled(vm.currentIndex == 0)

                        Button { vm.goNext() } label: {
                            HStack {
                                Text("Câu Sau")
                                Image(systemName: "chevron.right")
                            }
                            .font(.system(size: 16, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 14)
                            .background(Color.white)
                            .cornerRadius(30)
                            .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 2)
                        }
                        .disabled(vm.currentIndex >= vm.questions.count - 1)
                    }

                    Button { vm.submit(isAuto: false) } label: {
                        Text("Nộp bài")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(primaryGreen)
                            .cornerRadius(30)
                            .shadow(color: primaryGreen.opacity(0.3), radius: 5, x: 0, y: 4)
                    }
                }
                .padding(20)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(UIColor.systemGray6).opacity(0), Color(UIColor.systemGray6)]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .padding(.top, -30)
                )
            }
        }
    }

    private func progressValue() -> CGFloat {
        guard !vm.questions.isEmpty else { return 0 }
        return CGFloat(vm.currentIndex + 1) / CGFloat(vm.questions.count)
    }
}

struct QuizOptionRow: View {
    var text: String
    var isSelected: Bool
    var primaryColor: Color
    var onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(text)
                    .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                    .foregroundColor(.black)
                Spacer()
            }
            .padding(.vertical, 16)
            .padding(.horizontal, 20)
            .background(Color.white)
            .cornerRadius(16)
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(isSelected ? primaryColor : Color.clear, lineWidth: 2)
            )
            .shadow(color: Color.black.opacity(0.03), radius: 3, x: 0, y: 1)
        }
        .buttonStyle(.plain)
    }
}
