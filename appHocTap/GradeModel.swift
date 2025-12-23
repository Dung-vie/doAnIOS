//
//  GradeModel.swift
//  appHocTap
//
//  Created by User on 22.12.2025.
//

import Foundation
import SwiftUI

struct GradeModel: Identifiable, Codable {
    var id: String        // Ví dụ: "1", "2"
    var name: String      // Ví dụ: "Lớp 1"
    var icon: String      // Ví dụ: "pencil"
    var colorString: String // Ví dụ: "orange"
    
    // --- 1. Hàm chuyển đổi String -> Color gốc ---
    private var baseColor: Color {
        switch colorString.lowercased() {
        case "orange": return .orange
        case "yellow": return .yellow
        case "green":  return .green
        case "cyan":   return .cyan
        case "purple": return .purple
        case "blue":   return .blue
        case "red":    return .red
        case "gray":   return .gray
        default:       return .gray // Mặc định nếu không tìm thấy màu
        }
    }
    
    // --- 2. Màu dùng cho Icon (Đậm) ---
    var iconColor: Color {
        return baseColor
    }
    
    // --- 3. Màu dùng cho Nền (Nhạt - Opacity) ---
    var color: Color {
        return baseColor.opacity(0.35)
    }
}
