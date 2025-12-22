//
//  LoginView.swift
//  appHocTap
//
//  Created by  User on 15.12.2025.
//

import SwiftUI

struct LoginView: View {

    @State private var email: String = ""
    @State private var password: String = ""

    var body: some View {
        VStack(spacing: 24) {

            Spacer().frame(height: 40)

            // MARK: - Icon
            ZStack {
                Circle()
                    .fill(Color.green.opacity(0.2))
                    .frame(width: 96, height: 96)

                Image(systemName: "graduationcap.fill")
                    .font(.system(size: 36))
                    .foregroundColor(.green)
            }

            // MARK: - Title
            VStack(spacing: 8) {
                Text("Chào mừng trở lại!")
                    .font(.system(size: 28, weight: .bold))

                Text("Đăng nhập để tiếp tục học nào.")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }

            Spacer().frame(height: 20)

            // MARK: - Form
            VStack(alignment: .leading, spacing: 16) {

                // Email
                VStack(alignment: .leading, spacing: 6) {
                    Text("Email")
                        .font(.system(size: 14, weight: .medium))

                    HStack(spacing: 12) {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(.gray)

                        TextField("Nhập email của bạn", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(14)
                }

                // Password
                VStack(alignment: .leading, spacing: 6) {
                    Text("Mật khẩu")
                        .font(.system(size: 14, weight: .medium))

                    HStack(spacing: 12) {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)

                        SecureField("Nhập mật khẩu", text: $password)
                    }
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(14)
                }
            }

            Spacer().frame(height: 24)

            // MARK: - Login Button
            NavigationLink{
                SelectGradeView()
            } label: {
                Text("Đăng nhập")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(18)
                    .shadow(color: Color.green.opacity(0.3), radius: 10, y: 6)
            }

            // MARK: - Register Link
            HStack(spacing: 4) {
                Text("Chưa có tài khoản?")
                    .foregroundColor(.gray)

                NavigationLink{
                    RegisterView()
                } label: {
                    Text("Đăng ký ngay")
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                        .navigationBarHidden(true)
                }
            }
            .font(.system(size: 14))

            Spacer()
        }
        .padding(.horizontal, 24)
        .background(Color.white)
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}

