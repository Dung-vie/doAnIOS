//
//  RegisterView.swift
//  appHocTap
//
//  Created by  User on 15.12.2025.
//

import SwiftUI

struct RegisterView: View {

    
    @State private var fullName: String = ""
    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 24) {

            Spacer().frame(height: 40)

            // MARK: - Title
            VStack(spacing: 8) {
                Text("Tạo tài khoản")
                    .font(.system(size: 28, weight: .bold))

                Text("Bắt đầu hành trình học tập của bạn!")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }

            Spacer().frame(height: 20)

            // MARK: - Form
            VStack(alignment: .leading, spacing: 16) {

                // Họ và tên
                VStack(alignment: .leading, spacing: 6) {
                    Text("Họ và tên")
                        .font(.system(size: 14, weight: .medium))

                    TextField("Nhập họ và tên của bạn", text: $fullName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(14)
                }

                // Email
                VStack(alignment: .leading, spacing: 6) {
                    Text("Email")
                        .font(.system(size: 14, weight: .medium))

                    TextField("Nhập email của bạn", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(14)
                }

                // Mật khẩu
                VStack(alignment: .leading, spacing: 6) {
                    Text("Mật khẩu")
                        .font(.system(size: 14, weight: .medium))

                    SecureField("Nhập mật khẩu của bạn", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(14)
                }
            }

            Spacer().frame(height: 24)

            // MARK: - Register Button
            Button(action: {
                print("Đăng ký")
            }) {
                Text("Đăng ký")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(18)
            }

            // MARK: - Login Link
            HStack(spacing: 4) {
                Text("Đã có tài khoản?")
                    .foregroundColor(.gray)

                NavigationLink {
                    LoginView() 
                } label: {
                    Text("Đăng nhập")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                }
            }
            .font(.system(size: 14))

            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Color.white)
    }
}

//struct RegisterView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterView()
//    }
//}
