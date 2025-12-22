import SwiftUI

struct HistoryView: View {
    // Dữ liệu lấy từ Firebase về
    @State private var historyList: [QuizHistoryItem] = []
    @State private var isLoading = true
    
    // Màu xanh chủ đạo
    let primaryGreen = Color(red: 0.0, green: 0.85, blue: 0.45)

    var body: some View {
        ZStack {
            // Nền màu xám nhạt
            Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading) {
                // Tiêu đề
                Text("Lịch sử làm bài")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .padding(.top, 20)
                
                if isLoading {
                    // --- TRẠNG THÁI ĐANG TẢI ---
                    Spacer()
                    ProgressView("Đang tải dữ liệu từ Firebase...")
                        .progressViewStyle(CircularProgressViewStyle(tint: primaryGreen))
                        .scaleEffect(1.2)
                    Spacer()
                } else if historyList.isEmpty {
                    // --- TRẠNG THÁI KHÔNG CÓ DỮ LIỆU ---
                    VStack(spacing: 15) {
                        Spacer()
                        Image(systemName: "doc.text.magnifyingglass")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Bạn chưa làm bài quiz nào")
                            .font(.headline)
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    // --- TRẠNG THÁI CÓ DỮ LIỆU (HIỆN DANH SÁCH) ---
                    ScrollView {
                        LazyVStack(spacing: 15) {
                            ForEach(historyList) { item in
                                // --- BẤM VÀO ĐỂ XEM CHI TIẾT ---
                                NavigationLink(destination: WrongAnswersView(wrongAnswers: item.wrongAnswers)) {
                                    HistoryRow(item: item, primaryGreen: primaryGreen)
                                }
                                .buttonStyle(PlainButtonStyle()) // Giữ nguyên màu sắc gốc của thẻ
                            }
                        }
                        .padding()
                    }
                }
            }
        }
        // --- GỌI FIREBASE KHI MÀN HÌNH HIỆN LÊN ---
        .onAppear {
            MyDatabase.shared.getHistory { results in
                // Cập nhật dữ liệu lên giao diện
                self.historyList = results
                self.isLoading = false
            }
        }
    }
}

// --- COMPONENT CON: Một dòng lịch sử (Card) ---
struct HistoryRow: View {
    // Nhận vào QuizHistoryItem (Model của Firebase)
    let item: QuizHistoryItem
    let primaryGreen: Color
    
    // Tính phần trăm điểm để đổi màu (trên 50% là xanh, dưới là đỏ)
    var isPass: Bool {
        // Tránh lỗi chia cho 0
        guard item.totalQuestions > 0 else { return false }
        return Double(item.score) / Double(item.totalQuestions) >= 0.5
    }
    
    var body: some View {
        HStack {
            // Cột 1: Thông tin ngày giờ & Trạng thái
            VStack(alignment: .leading, spacing: 6) {
                // Hiển thị ngày tháng (đã có sẵn string từ Firebase)
                Text(item.dateString)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                HStack {
                    // Huy hiệu Đạt / Chưa đạt
                    Text(isPass ? "Đạt" : "Chưa đạt")
                        .font(.caption)
                        .fontWeight(.bold)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(isPass ? primaryGreen.opacity(0.15) : Color.red.opacity(0.15))
                        .foregroundColor(isPass ? primaryGreen : Color.red)
                        .cornerRadius(6)
                    
                    // --- Dòng nhắc nhở xem lại câu sai ---
                    if !item.wrongAnswers.isEmpty {
                        Text("Xem \(item.wrongAnswers.count) câu sai ›")
                            .font(.caption)
                            .fontWeight(.medium)
                            .foregroundColor(.orange)
                    }
                }
            }
            
            Spacer()
            
            // Cột 2: Điểm số to rõ
            VStack(alignment: .trailing) {
                Text("\(item.score)/\(item.totalQuestions)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                
                Text("Câu đúng")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 3, x: 0, y: 1)
    }
}

// Preview (Chỉ để check lỗi cú pháp trên Windows)
struct HistoryView_Previews: PreviewProvider {
    static var previews: some View {
        HistoryView()
    }
}