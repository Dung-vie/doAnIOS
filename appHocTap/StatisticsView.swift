import SwiftUI

struct StatisticsView: View {
    // --- CÁC BIẾN LƯU KẾT QUẢ TÍNH TOÁN ---
    @State private var totalCorrect: Int = 0        // Tổng câu đúng
    @State private var totalWrong: Int = 0          // Tổng câu sai
    @State private var averageScore: Double = 0.0   // Điểm trung bình (thang 10)
    @State private var totalGames: Int = 0          // Tổng số bài đã làm
    
    @State private var isLoading = true
    
    // Màu sắc chủ đạo
    let primaryGreen = Color(red: 0.0, green: 0.85, blue: 0.45)
    
    var body: some View {
        ZStack {
            // Nền xám nhạt
            Color(UIColor.systemGray6).edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // Header
                    Text("Thống kê chi tiết")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.top, 20)
                    
                    if isLoading {
                        HStack {
                            Spacer()
                            ProgressView("Đang tải dữ liệu từ Firebase...")
                            Spacer()
                        }
                        .padding(50)
                    } else if totalGames == 0 {
                        // Trường hợp chưa làm bài nào
                        VStack(spacing: 15) {
                            Image(systemName: "chart.pie.fill")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            Text("Chưa có dữ liệu thống kê")
                                .foregroundColor(.gray)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 50)
                    } else {
                        // --- HIỂN THỊ CÁC THẺ THỐNG KÊ ---
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                            
                            // 1. Thẻ ĐIỂM TRUNG BÌNH (Quan trọng nhất)
                            StatCard(
                                title: "Điểm Trung Bình",
                                value: String(format: "%.1f", averageScore),
                                subtitle: "Thang điểm 10",
                                icon: "star.fill",
                                color: .orange
                            )
                            
                            // 2. Thẻ TỔNG SỐ BÀI
                            StatCard(
                                title: "Bài Đã Làm",
                                value: "\(totalGames)",
                                subtitle: "Lượt chơi",
                                icon: "gamecontroller.fill",
                                color: .blue
                            )
                            
                            // 3. Thẻ TỔNG CÂU ĐÚNG
                            StatCard(
                                title: "Tổng Câu Đúng",
                                value: "\(totalCorrect)",
                                subtitle: "Câu trả lời",
                                icon: "checkmark.circle.fill",
                                color: primaryGreen
                            )
                            
                            // 4. Thẻ TỔNG CÂU SAI
                            StatCard(
                                title: "Tổng Câu Sai",
                                value: "\(totalWrong)",
                                subtitle: "Cần cải thiện",
                                icon: "xmark.circle.fill",
                                color: .red
                            )
                        }
                        
                        // Biểu đồ thanh đơn giản (Visual)
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Tỉ lệ Đúng / Sai")
                                .font(.headline)
                                .padding(.top)
                            
                            GeometryReader { geometry in
                                HStack(spacing: 0) {
                                    // Phần màu xanh (Đúng)
                                    Rectangle()
                                        .fill(primaryGreen)
                                        .frame(width: geometry.size.width * getCorrectRatio())
                                    
                                    // Phần màu đỏ (Sai)
                                    Rectangle()
                                        .fill(Color.red)
                                }
                            }
                            .frame(height: 20)
                            .cornerRadius(10)
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                            )
                            
                            HStack {
                                Circle().fill(primaryGreen).frame(width: 10, height: 10)
                                Text("Đúng").font(.caption)
                                Spacer()
                                Circle().fill(Color.red).frame(width: 10, height: 10)
                                Text("Sai").font(.caption)
                            }
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(15)
                        .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
                    }
                }
                .padding()
            }
        }
        // --- GỌI HÀM TÍNH TOÁN KHI MÀN HÌNH HIỆN ---
        .onAppear {
            calculateStatsFromFirebase()
        }
    }
    
    // --- LOGIC TÍNH TOÁN TỪ FIREBASE ---
    func calculateStatsFromFirebase() {
        // Gọi hàm getHistory đã viết trong MyDatabase.swift
        MyDatabase.shared.getHistory { historyList in
            
            // Nếu không có dữ liệu
            if historyList.isEmpty {
                self.isLoading = false
                return
            }
            
            var sumCorrect = 0
            var sumTotalQuestions = 0
            
            // Duyệt qua từng bài làm để cộng dồn
            for item in historyList {
                sumCorrect += item.score
                sumTotalQuestions += item.totalQuestions
            }
            
            // Tính toán ra các chỉ số
            let wrongs = sumTotalQuestions - sumCorrect
            
            // Tính điểm trung bình: (Tổng đúng / Tổng câu hỏi) * 10
            let avg: Double = sumTotalQuestions > 0 ? (Double(sumCorrect) / Double(sumTotalQuestions)) * 10.0 : 0.0
            
            // Cập nhật lên giao diện
            self.totalGames = historyList.count
            self.totalCorrect = sumCorrect
            self.totalWrong = wrongs
            self.averageScore = avg
            
            self.isLoading = false
        }
    }
    
    // Hàm phụ tính tỉ lệ vẽ biểu đồ
    func getCorrectRatio() -> CGFloat {
        let total = totalCorrect + totalWrong
        if total == 0 { return 0.5 } // Mặc định 50-50 nếu chưa có dữ liệu
        return CGFloat(totalCorrect) / CGFloat(total)
    }
}

// --- COMPONENT CON: THẺ STAT CARD ---
struct StatCard: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(color)
                    .padding(10)
                    .background(color.opacity(0.1))
                    .clipShape(Circle())
                Spacer()
            }
            
            Text(value)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(.black)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.gray)
                Text(subtitle)
                    .font(.caption)
                    .foregroundColor(.gray.opacity(0.8))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.05), radius: 5, y: 2)
    }
}

// Preview
struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}