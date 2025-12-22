//
//  SubjectModel.swift
//  appHocTap
//
//  Created by  User on 21.12.2025.
//

import Foundation
import SwiftUI

struct SubjectModel: Identifiable {
    let id: String
    let name: String
    let subtitle: String
    let icon: String
    let colorString: String
    
    // Hàm chuyển đổi chữ "orange" trên mạng thành màu cam thật trong app
    var color: Color {
        switch colorString {
        case "orange": return .orange.opacity(0.2)
        case "blue": return .blue.opacity(0.15)
        case "green": return .green.opacity(0.15)
        default: return .gray.opacity(0.2)
        }
    }
    
    // Màu cho cái icon bên trong
    var iconColor: Color {
        switch colorString {
        case "orange": return .orange
        case "blue": return .blue
        case "green": return .green
        default: return .gray
        }
    }
}
