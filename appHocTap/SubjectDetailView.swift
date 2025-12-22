import SwiftUI
import Foundation

struct SubjectDetailView: View {

    @Environment(\.dismiss) private var dismiss

    let subjectKey: String
    let title: String
    let items: [LessonRowModel]

    // chọn bài nào thì set lessonKey
    @State private var selectedLessonKey: String = "practice"
    @State private var selectedLessonId: String? = nil

    @State private var showTimeSettings = false
    @State private var selectedIsUnlimited = false
    @State private var selectedMinutes = 10

    @State private var pendingStartQuiz = false
    @State private var startQuiz = false
    @State private var quizSessionId = UUID()

    init(title: String, items: [LessonRowModel], subjectKey: String) {
        self.title = title
        self.items = items
        self.subjectKey = subjectKey
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 14) {

                // Header
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

                // Hidden NavigationLink -> Quiz screen
                NavigationLink(
                    destination: QuizQuestionScreen(
                        bankKey: subjectKey,
                        lessonId: selectedLessonId, // ví dụ "lesson1" / "lesson2" / "practice"
                        isUnlimited: selectedIsUnlimited,
                        minutes: selectedMinutes
                    )
                    .id(quizSessionId),
                    isActive: $startQuiz
                ) { EmptyView() }
                .hidden()

                VStack(spacing: 14) {
                    ForEach(items) { item in
                        Button {
                            // ✅ bấm bài nào cũng mở quiz
                            selectedLessonKey = item.lessonKey
                            showTimeSettings = true
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
        .sheet(isPresented: $showTimeSettings, onDismiss: {
            if pendingStartQuiz {
                pendingStartQuiz = false
                startQuiz = true
            }
        }) {
            QuizTimeSettingsView(
                initialIsUnlimited: selectedIsUnlimited,
                initialMinutes: selectedMinutes
            ) { isUnlimited, minutes in
                selectedIsUnlimited = isUnlimited
                selectedMinutes = minutes

                // reset session để SwiftUI không cache màn quiz cũ
                quizSessionId = UUID()

                pendingStartQuiz = true
                showTimeSettings = false
            }
        }
    }
}

// MARK: - Card
private struct LessonCard: View {
    let item: LessonRowModel

    var body: some View {
        HStack(spacing: 14) {

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
