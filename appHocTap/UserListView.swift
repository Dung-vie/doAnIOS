//
//  UserListView.swift
//  appHocTap
//
//  Created by  User on 15.12.2025.
//

import SwiftUI

struct UserListView: View {
    var body: some View {
        NavigationStack {
            List {
                UserRow(name: "Nguyễn Văn A", email: "a@gmail.com")
                UserRow(name: "Trần Thị B", email: "b@gmail.com")
            }
            .navigationTitle("Quản lý Người dùng")
        }
    }
}


struct UserRow: View {
    let name: String
    let email: String

    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .font(.title2)

            VStack(alignment: .leading) {
                Text(name).font(.headline)
                Text(email).font(.caption)
            }

            Spacer()

            Image(systemName: "trash")
                .foregroundColor(.red)
        }
        .padding(.vertical, 8)
    }
}


//struct UserListView_Previews: PreviewProvider {
//    static var previews: some View {
//        UserListView()
//    }
//}
