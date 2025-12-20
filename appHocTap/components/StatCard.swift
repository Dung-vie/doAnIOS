//
//  StatCard.swift
//  appHocTap
//
//  Created by  User on 15.12.2025.
//

import SwiftUI

struct StatCard: View {
    let title: String
    let value: String

        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Text(value)
                    .font(.title2)
                    .fontWeight(.bold)
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: .black.opacity(0.05), radius: 4, x: 0, y: 2)
        }

}

//struct StatCard_Previews: PreviewProvider {
//    static var previews: some View {
//        StatCard()
//    }
//}
