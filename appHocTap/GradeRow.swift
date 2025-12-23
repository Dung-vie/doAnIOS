//
//  GradeRow.swift
//  appHocTap
//
//  Created by  User on 16.12.2025.
//

import SwiftUI

struct GradeRow: View {
    let title: String
        let icon: String
        let bgColor: Color
        let iconColor: Color

        var body: some View {
            Button(action: {
                print("Chọn \(title)")
            }) {
                HStack(spacing: 16) {

                    // Icon
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.6))
                            .frame(width: 44, height: 44)

                        Image(systemName: icon)
                            .font(.system(size: 20, weight: .bold))
                            .foregroundColor(iconColor)
                    }

                    // Title
                    Text(title)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(iconColor)

                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity, minHeight: 72)
                .background(bgColor)
                .cornerRadius(22)
            }
        }
    }

//struct GradeRow_Previews: PreviewProvider {
//    static var previews: some View {
//        GradeRow()
//    }
//}
