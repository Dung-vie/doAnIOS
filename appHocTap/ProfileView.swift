//
//  ProfileView.swift
//  appHocTap
//
//  Created by  User on 15.12.2025.
//

import SwiftUI

struct ProfileView: View {

    @Environment(\.dismiss) private var dismiss

    // Demo data (sau này bạn nối từ ViewModel / API / UserDefaults)
    private let childName: String = "Tên của bé"
    private let practiceCount: Int = 12

    private let lessons: [LessonItem] = [
        .init(title: "Bài 1: Bảng Chữ Cái", detail: "8/10 câu", status: .done),
        .init(title: "Bài 2: Các con số", detail: "Điểm tuyệt đối!", status: .perfect),
        .init(title: "Bài 3: Các loài động vật", detail: "9/10 câu", status: .done)
    ]

    var body: some View {
        ScrollView {
            VStack(spacing: 18) {

                // Header: back + title
                HStack {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3.weight(.semibold))
                            .foregroundColor(.black)
                            .frame(width: 44, height: 44)
                    }

                    Spacer()

                    Text("Hồ Sơ Học Tập")
                        .font(.system(size: 20, weight: .bold))

                    Spacer()

                    // spacer to keep title centered
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, 16)
                .padding(.top, 8)

                // Avatar
                VStack(spacing: 12) {
                    ZStack {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 120, height: 120)
                            .shadow(color: .black.opacity(0.08), radius: 10, x: 0, y: 6)

                        // Nếu bạn có ảnh asset: thay bằng Image("avatar").resizable()...
                        Image(systemName: "person.crop.circle.fill")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.gray.opacity(0.6))
                            .frame(width: 110, height: 110)
                            .clipShape(Circle())
                    }

                    Text(childName)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.black)
                }
                .padding(.top, 8)

                // Practice card
                ProfileStatCard(title: "Số Lần Luyện Tập", value: "\(practiceCount)")

                // Section: lessons
                VStack(alignment: .leading, spacing: 12) {
                    Text("Các Bài Đã Học")
                        .font(.system(size: 22, weight: .bold))
                        .padding(.horizontal, 16)
                        .padding(.top, 6)

                    VStack(spacing: 14) {
                        ForEach(lessons) { item in
                            LessonRow(item: item) {
                                // TODO: handle retry
                                // print("Retry \(item.title)")
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                }

                // Logout
                Button {
                    // TODO: handle logout
                    // Ví dụ: clear user session, navigate to login, etc.
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "rectangle.portrait.and.arrow.right")
                            .font(.title3.weight(.semibold))
                        Text("Đăng xuất")
                            .font(.system(size: 18, weight: .semibold))
                    }
                    .foregroundColor(.red)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(Color.red.opacity(0.12))
                    .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                }

                Spacer(minLength: 10)
            }
            .padding(.bottom, 24)
        }
        .background(Color(white: 0.96).ignoresSafeArea())
        .navigationBarHidden(true) // vì mình custom header
    }
}

// MARK: - Models

struct LessonItem: Identifiable {
    enum Status {
        case done
        case perfect
    }

    let id = UUID()
    let title: String
    let detail: String
    let status: Status
}

// MARK: - Components

private struct ProfileStatCard: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "figure.strengthtraining.traditional")
                .foregroundColor(.green)
                .font(.title3)

            Text(title)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.gray)

            Text(value)
                .font(.system(size: 32, weight: .bold))
                .foregroundColor(.black)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 22)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 12, x: 0, y: 8)
        .padding(.horizontal, 16)
    }
}

private struct LessonRow: View {
    let item: LessonItem
    let onRetry: () -> Void

    var body: some View {
        HStack(spacing: 14) {
            // Left status icon
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.18))
                    .frame(width: 56, height: 56)

                Image(systemName: item.status == .perfect ? "star.fill" : "checkmark")
                    .foregroundColor(.green)
                    .font(.title3.weight(.bold))
            }

            // Title + detail
            VStack(alignment: .leading, spacing: 4) {
                Text(item.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(.black)

                if item.status == .perfect {
                    Text(item.detail)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.green)
                } else {
                    Text(item.detail)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.gray)
                }
            }

            Spacer()

            // Retry button
            Button(action: onRetry) {
                ZStack {
                    Circle()
                        .fill(Color.gray.opacity(0.12))
                        .frame(width: 44, height: 44)

                    Image(systemName: "arrow.clockwise")
                        .foregroundColor(.black)
                        .font(.title3.weight(.semibold))
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 14)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.06), radius: 10, x: 0, y: 6)
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
