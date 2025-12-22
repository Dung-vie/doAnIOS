//
//  AdminActionCard.swift
//  appHocTap
//
//  Created by  User on 15.12.2025.
//

import SwiftUI

struct AdminActionCard: View {
    let icon: String
    let title: String
    let subtitle: String
    
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 32))
                .foregroundColor(.green)
            
            Text(title)
                .font(.headline)
            
            Text(subtitle)
                .font(.caption)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .frame(height: 150)
        .background(Color.green.opacity(0.15))
        .cornerRadius(16)
    }
}

//struct AdminActionCard_Previews: PreviewProvider {
//    static var previews: some View {
//        AdminActionCard()
//    }
//}
