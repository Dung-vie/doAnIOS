//
//  ConfirmDeleteView.swift
//  appHocTap
//
//  Created by  User on 15.12.2025.
//

import SwiftUI

struct ConfirmDeleteView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("Xác nhận xóa")
                .font(.headline)

            Text("Bạn có chắc chắn muốn xóa không?")
                .font(.caption)

            HStack {
                Button("Hủy") {}
                    .frame(maxWidth: .infinity)

                Button("Xóa") {}
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(8)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}


//struct ConfirmDeleteView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmDeleteView()
//    }
//}
