//
//  QuizTimeSettingsView.swift
//  appHocTap
//
//  Created by  User on 15.12.2025.
//

import SwiftUI

struct QuizTimeSettingsView: View {

    @Environment(\.dismiss) private var dismiss

    // Trả kết quả về màn trước
    let onSave: (_ isUnlimited: Bool, _ minutes: Int) -> Void

    @State private var isUnlimited: Bool = false
    @State private var selectedMinutes: Int = 10

    private let minuteOptions: [Int] = [5, 10, 15, 20, 30, 45, 60]

    var body: some View {
        VStack(spacing: 18) {

            // Header
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .font(.title3.weight(.semibold))
                        .foregroundColor(.black)
                        .frame(width: 44, height: 44)
                }

                Spacer()

                Text("Cài đặt Thời gian Quiz")
                    .font(.system(size: 18, weight: .bold))

                Spacer()

                Color.clear.frame(width: 44, height: 44)
            }
            .padding(.horizontal, 16)
            .padding(.top, 8)

            // Icon + subtitle
            VStack(spacing: 12) {
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.18))
                        .frame(width: 92, height: 92)

                    Image(systemName: "hourglass")
                        .font(.system(size: 40, weight: .semibold))
                        .foregroundColor(.green)
                }

                Text("Chọn thời gian làm bài nhé!")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.gray)
            }
            .padding(.top, 10)

            // Options
            VStack(spacing: 14) {

                // 1) Unlimited
                OptionRow(
                    title: "Không giới hạn thời gian",
                    isSelected: isUnlimited
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isUnlimited = true
                    }
                }

                // 2) Custom time
                CustomTimeRow(
                    title: "Tùy chỉnh thời gian",
                    isSelected: !isUnlimited,
                    selectedMinutes: $selectedMinutes,
                    minuteOptions: minuteOptions
                ) {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        isUnlimited = false
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.top, 10)

            Spacer()

            // Save
            Button {
                onSave(isUnlimited, selectedMinutes)
                dismiss()
            } label: {
                Text("Lưu")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 18)
                    .background(Color.green)
                    .clipShape(Capsule())
                    .padding(.horizontal, 16)
            }
            .padding(.bottom, 18)
        }
        .background(Color(white: 0.96).ignoresSafeArea())
    }
}

// MARK: - Option Row

private struct OptionRow: View {
    let title: String
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)

                Spacer()

                Circle()
                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                    .frame(width: 22, height: 22)
                    .overlay(
                        Circle()
                            .fill(isSelected ? Color.green : Color.clear)
                            .frame(width: 12, height: 12)
                    )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 18)
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Custom Time Row

private struct CustomTimeRow: View {
    let title: String
    let isSelected: Bool

    @Binding var selectedMinutes: Int
    let minuteOptions: [Int]

    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.black)

                Spacer()

                // Dropdown minutes
                Menu {
                    ForEach(minuteOptions, id: \.self) { m in
                        Button("\(m) phút") {
                            selectedMinutes = m
                        }
                    }
                } label: {
                    HStack(spacing: 6) {
                        Text("\(selectedMinutes) phút")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(.black)

                        Image(systemName: "chevron.down")
                            .font(.system(size: 12, weight: .semibold))
                            .foregroundColor(.gray)
                    }
                    .padding(.horizontal, 14)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.75))
                    .clipShape(Capsule())
                }

                Circle()
                    .stroke(Color.gray.opacity(0.5), lineWidth: 2)
                    .frame(width: 22, height: 22)
                    .overlay(
                        Circle()
                            .fill(isSelected ? Color.green : Color.clear)
                            .frame(width: 12, height: 12)
                    )
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 18)
            .background(isSelected ? Color.green.opacity(0.15) : Color.white)
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(isSelected ? Color.green : Color.clear, lineWidth: 2)
            )
            .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
            .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}
struct QuizTimeSettingsView_Previews: PreviewProvider {
    static var previews: some View {
        QuizTimeSettingsView { _, _ in }
            .preferredColorScheme(.light)
    }
}

