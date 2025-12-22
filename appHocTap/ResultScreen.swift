//
//  ResultScreen.swift
//  appHocTap
//
//  Created by  User on 16.12.2025.
//

import SwiftUI

struct ResultScreen: View {
    let primaryGreen = Color(red: 0.0, green: 0.85, blue: 0.45)
    let primaryRed = Color(red: 1.0, green: 0.4, blue: 0.4)

    let result: QuizResult
    let onRestart: () -> Void
    let onHome: () -> Void

    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()

            VStack(spacing: 0) {

                HStack {
                    Button(action: onHome) {
                        Image(systemName: "xmark")
                            .font(.system(size: 20))
                            .foregroundColor(.black)
                    }

                    Spacer()

                    Text("Kết quả bài quiz")
                        .font(.headline)
                        .fontWeight(.bold)

                    Spacer()

                    Image(systemName: "xmark").hidden()
                }
                .padding()

                VStack(spacing: 8) {
                    Text("Bạn đúng \(result.correctCount)/\(result.fixedTotal) câu")
                        .font(.system(size: 28, weight: .heavy))
                        .foregroundColor(.black)

                    if let t = result.timeUsedSeconds {
                        Text("Thời gian: \(t/60) phút \(t%60) giây")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    } else {
                        Text("Không giới hạn thời gian")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                }
                .padding(.vertical, 20)

                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Xem lại đáp án")
                            .font(.headline)
                            .fontWeight(.bold)
                            .padding(.horizontal)

                        VStack(spacing: 12) {
                            ForEach(result.reviewItems) { item in
                                AnswerRow(
                                    title: item.title,
                                    userChoice: item.userChoice,
                                    correctChoice: item.isCorrect ? nil : item.correctChoice,
                                    isCorrect: item.isCorrect,
                                    primaryGreen: primaryGreen,
                                    primaryRed: primaryRed
                                )
                            }
                        }
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                }

                VStack(spacing: 12) {
                    Button(action: onRestart) {
                        Text("Làm lại")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(primaryGreen)
                            .cornerRadius(30)
                    }

                    Button(action: onHome) {
                        Text("Về Home")
                            .font(.headline)
                            .fontWeight(.bold)
                            .foregroundColor(.black)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(primaryGreen.opacity(0.25))
                            .cornerRadius(30)
                    }
                }
                .padding(20)
            }
        }
    }
}

struct AnswerRow: View {
    let title: String
    let userChoice: String
    var correctChoice: String? = nil
    let isCorrect: Bool
    let primaryGreen: Color
    let primaryRed: Color

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            ZStack {
                Circle()
                    .fill(isCorrect ? primaryGreen.opacity(0.15) : primaryRed.opacity(0.15))
                    .frame(width: 40, height: 40)

                Image(systemName: isCorrect ? "checkmark" : "xmark")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(isCorrect ? primaryGreen : primaryRed)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(.black)

                Text("Bạn đã chọn: \(userChoice)")
                    .font(.system(size: 13))
                    .foregroundColor(.gray)

                if !isCorrect, let correct = correctChoice {
                    Text("Đáp án đúng: \(correct)")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(primaryGreen)
                }
            }

            Spacer()

            Text(isCorrect ? "Đúng" : "Sai")
                .font(.system(size: 14, weight: .bold))
                .foregroundColor(isCorrect ? primaryGreen : primaryRed)
                .padding(.top, 4)
        }
        .padding(16)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.04), radius: 5, x: 0, y: 2)
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.gray.opacity(0.1), lineWidth: 1)
        )
    }
}
