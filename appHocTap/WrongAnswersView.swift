import SwiftUI

struct WrongAnswersView: View {
    // Nhận vào danh sách câu sai của lần thi đó
    var wrongAnswers: [ReviewItem]
    
    // Màu sắc
    let primaryRed = Color(red: 1.0, green: 0.4, blue: 0.4)
    let primaryGreen = Color(red: 0.0, green: 0.85, blue: 0.45)

    var body: some View {
        ZStack {
            Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                // Header
                Text("Xem lại câu sai")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 20)
                    .padding(.horizontal)
                
                if wrongAnswers.isEmpty {
                    // Trường hợp làm đúng hết (không có câu sai)
                    VStack {
                        Spacer()
                        Image(systemName: "star.fill")
                            .font(.system(size: 60))
                            .foregroundColor(.yellow)
                            .padding()
                        Text("Xuất sắc! Bạn không sai câu nào.")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    // Danh sách câu sai
                    ScrollView {
                        VStack(spacing: 15) {
                            ForEach(wrongAnswers) { item in
                                WrongAnswerCard(item: item, green: primaryGreen, red: primaryRed)
                            }
                        }
                        .padding()
                    }
                }
            }
        }
    }
}

// --- Component con: Thẻ hiển thị 1 câu sai ---
struct WrongAnswerCard: View {
    let item: ReviewItem
    let green: Color
    let red: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            // Câu hỏi
            HStack(alignment: .top) {
                Image(systemName: "questionmark.circle.fill")
                    .foregroundColor(.orange)
                Text(item.questionText)
                    .font(.headline)
                    .fontWeight(.bold)
                    .fixedSize(horizontal: false, vertical: true) // Tự xuống dòng
            }
            
            Divider()
            
            // Câu trả lời của bạn (SAI)
            HStack {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(red)
                VStack(alignment: .leading) {
                    Text("Bạn đã chọn:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(item.userChoice)
                        .fontWeight(.semibold)
                        .foregroundColor(red)
                }
            }
            
            // Đáp án đúng (ĐÚNG)
            HStack {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundColor(green)
                VStack(alignment: .leading) {
                    Text("Đáp án đúng:")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text(item.correctChoice)
                        .fontWeight(.semibold)
                        .foregroundColor(green)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}