import SwiftUI

struct HomeView: View {

    enum Tab {
        case profile
        case time
    }

    @State private var selectedTab: Tab = .profile
    @State private var subjects: [SubjectModel] = []
    // ✅ Data demo cho từng môn
    private var mathItems: [LessonRowModel] {
        [
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
    }

    private var literatureItems: [LessonRowModel] {
        [
            .init(iconSystemName: "pencil.and.outline", iconBg: Color.blue.opacity(0.18),
                  title: "Luyện Tập", subtitle: "Câu hỏi tổng hợp", status: .none),
            .init(iconSystemName: "text.book.closed", iconBg: Color.green.opacity(0.18),
                  title: "Bài 1: Bảng chữ cái", subtitle: "Nhận biết chữ", status: .none),
            .init(iconSystemName: "quote.opening", iconBg: Color.green.opacity(0.18),
                  title: "Bài 2: Từ vựng cơ bản", subtitle: "", status: .done),
            .init(iconSystemName: "doc.text", iconBg: Color.green.opacity(0.18),
                  title: "Bài 3: Đọc hiểu ngắn", subtitle: "", status: .notDone),
            .init(iconSystemName: "book", iconBg: Color.green.opacity(0.18),
                  title: "Bài 4: Kể chuyện", subtitle: "Luyện tập kể chuyện", status: .none),
            .init(iconSystemName: "signature", iconBg: Color.green.opacity(0.18),
                  title: "Bài 5: Tập viết", subtitle: "Luyện tập viết chữ", status: .none)
        ]
    }

    private var englishItems: [LessonRowModel] {
        [
            .init(iconSystemName: "speaker.wave.2.fill", iconBg: Color.blue.opacity(0.18),
                  title: "Luyện Tập", subtitle: "Nghe - nói tổng hợp", status: .none),
            .init(iconSystemName: "character.book.closed", iconBg: Color.green.opacity(0.18),
                  title: "Bài 1: Alphabet", subtitle: "Nhận biết chữ cái", status: .none),
            .init(iconSystemName: "textformat.abc", iconBg: Color.green.opacity(0.18),
                  title: "Bài 2: Từ vựng chủ đề", subtitle: "", status: .done),
            .init(iconSystemName: "mic.fill", iconBg: Color.green.opacity(0.18),
                  title: "Bài 3: Phát âm cơ bản", subtitle: "", status: .notDone),
            .init(iconSystemName: "book.fill", iconBg: Color.green.opacity(0.18),
                  title: "Bài 4: Reading", subtitle: "Đọc hiểu đơn giản", status: .none),
            .init(iconSystemName: "pencil", iconBg: Color.green.opacity(0.18),
                  title: "Bài 5: Writing", subtitle: "Tập viết câu ngắn", status: .none)
        ]
    }

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    HStack {
                        Image(systemName: "graduationcap.fill")
                            .foregroundColor(.green)
                            .font(.title2)

                        Spacer()

                        NavigationLink(destination: ProfileView()) {
                            Image(systemName: "person.fill")
                                .foregroundColor(.black)
                                .font(.title2)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)

                    Text("Quiz Học Tập")
                        .font(.system(size: 28, weight: .bold))
                        .padding(.horizontal, 20)

                    HStack(spacing: 8) {
                        tabButton(title: "Hồ sơ học tập", isSelected: selectedTab == .profile) {
                            withAnimation { selectedTab = .profile }
                        }

                        tabButton(title: "Thời gian", isSelected: selectedTab == .time) {
                            withAnimation { selectedTab = .time }
                        }
                    }
                    .padding(6)
                    .background(Color.gray.opacity(0.15))
                    .clipShape(Capsule())
                    .padding(.horizontal, 20)

                    Text("Chọn Môn Học")
                        .font(.system(size: 20, weight: .bold))
                        .padding(.horizontal, 20)

                    // MARK: - Grid Môn Học (Dynamic)
                                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                                            ForEach(subjects) { subject in
                                                // Gọi hàm getDestinationView để lấy màn hình đích
                                                NavigationLink(destination: getDestinationView(for: subject)) {
                                                    subjectCard(
                                                        icon: subject.icon,
                                                        bgColor: subject.color,
                                                        title: subject.name,
                                                        subtitle: subject.subtitle,
                                                        iconColor: subject.iconColor
                                                    )
                                                }
                                                .buttonStyle(.plain)
                                            }
                                        }
                                        .padding(.horizontal, 20)
                    Spacer()
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                print("Đang tải danh sách môn học...")
                
                MyDatabase.shared.getSubjects { downloadedSubjects in
                    // Bắt buộc cập nhật UI trên luồng chính (Main Thread)
                    DispatchQueue.main.async {
                        self.subjects = downloadedSubjects
                    }
                    print("Đã tải xong: \(downloadedSubjects.count) môn")
                }
            }
        }
    }

    private func tabButton(
        title: String,
        isSelected: Bool,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(.black)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 10)
                .background(isSelected ? Color.green : Color.clear)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
    }

private func subjectCard(icon: String, bgColor: Color, title: String, subtitle: String, iconColor: Color) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(bgColor)
                    .frame(height: 140)

                Image(systemName: icon)
                        .font(.system(size: 40))
                        .foregroundColor(iconColor)
            }

            Text(title)
                .font(.headline)

            Text(subtitle)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
    
    // Hàm này giúp tách logic ra khỏi body, tránh lỗi compiler timeout
        @ViewBuilder
        private func getDestinationView(for subject: SubjectModel) -> some View {
            if subject.id == "toan" {
                SubjectDetailView(title: subject.name, items: mathItems)
            } else if subject.id == "van" {
                SubjectDetailView(title: subject.name, items: literatureItems)
            } else {
                SubjectDetailView(title: subject.name, items: englishItems)
            }
        }
}

//struct HomeView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView()
//    }
//}
