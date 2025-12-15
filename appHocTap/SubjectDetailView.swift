//
//  SubjectDetailView.swift
//  appHocTap
//
//  Created by  User on 15.12.2025.
//

import SwiftUI

struct SubjectDetailView: View {

    @Environment(\.dismiss) private var dismiss
    @State private var showTimeSettings = false
    @State private var quizTimeText: String = "10 phút"

    let title: String
    let items: [LessonRowModel]

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {

                // Header (back + title)
                HStack {
                    Button { dismiss() } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.black)
                            .frame(width: 44, height: 44)
                    }

                    Spacer()

                    Text(title)
                        .font(.system(size: 20, weight: .bold))

                    Spacer()

                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                VStack(spacing: 14) {
                    ForEach(items) { item in
                        Button {
                            if item.title == "Luyện Tập" {
                                showTimeSettings = true
                            } else {
                                // TODO: mở bài học
                            }
                        } label: {
                            LessonCard(item: item)
                        }
                        .buttonStyle(.plain)
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
        .sheet(isPresented: $showTimeSettings) {
            QuizTimeSettingsView { isUnlimited, minutes in
                quizTimeText = isUnlimited ? "Không giới hạn" : "\(minutes) phút"
                // TODO: lưu setting này để dùng khi bắt đầu quiz
            }
        }

    }
}

// MARK: - Model

struct LessonRowModel: Identifiable {
    enum Status {
        case none
        case done
        case notDone
    }

    let id = UUID()
    let iconSystemName: String
    let iconBg: Color
    let title: String
    let subtitle: String
    let status: Status
}

// MARK: - Card

private struct LessonCard: View {
    let item: LessonRowModel

    var body: some View {
        HStack(spacing: 14) {

            // Icon box
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(item.iconBg)
                    .frame(width: 52, height: 52)

                Image(systemName: item.iconSystemName)
                    .font(.title3.weight(.semibold))
                    .foregroundColor(.black.opacity(0.85))
            }

            VStack(alignment: .leading, spacing: 6) {
                Text(item.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)

                if item.status == .done {
                    HStack(spacing: 6) {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(.green)
                        Text("Đã hoàn thành")
                            .foregroundColor(.green)
                            .font(.system(size: 15, weight: .semibold))
                    }
                } else if item.status == .notDone {
                    HStack(spacing: 6) {
                        Image(systemName: "clock")
                            .foregroundColor(.orange)
                        Text("Chưa hoàn thành")
                            .foregroundColor(.orange)
                            .font(.system(size: 15, weight: .semibold))
                    }
                } else {
                    Text(item.subtitle)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            Image(systemName: "chevron.right")
                .foregroundColor(.gray.opacity(0.7))
                .font(.title3.weight(.semibold))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 18)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
    }
}

struct SubjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            SubjectDetailView(
                title: "Toán Lớp 1",
                items: [
                    .init(iconSystemName: "dumbbell.fill", iconBg: Color.blue.opacity(0.18),
                          title: "Luyện Tập", subtitle: "Câu hỏi tổng hợp", status: .none),

                    .init(iconSystemName: "123.rectangle.fill", iconBg: Color.green.opacity(0.18),
                          title: "Bài 1: Đếm số từ 1 đến 10", subtitle: "Luyện tập nhận biết số", status: .none),

                    .init(iconSystemName: "arrow.left.arrow.right", iconBg: Color.green.opacity(0.18),
                          title: "Bài 2: So Sánh Lớn Hơn, Nhỏ Hơn", subtitle: "", status: .done),

                    .init(iconSystemName: "plus", iconBg: Color.green.opacity(0.18),
                          title: "Bài 3: Phép Cộng Đơn Giản", subtitle: "", status: .notDone),

                    .init(iconSystemName: "triangle.square.circle", iconBg: Color.green.opacity(0.18),
                          title: "Bài 4: Hình Học Vui Nhộn", subtitle: "Nhận biết các hình khối", status: .none),

                    .init(iconSystemName: "minus", iconBg: Color.green.opacity(0.18),
                          title: "Bài 5: Phép Trừ Cơ Bản", subtitle: "Luyện tập phép trừ", status: .none)
                ]
            )
        }
    }
}

