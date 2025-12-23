//
//  LoginView.swift
//  appHocTap
//
//  Created by  User on 15.12.2025.
//

import SwiftUI
import FirebaseAuth

struct LoginView: View {
    
    @State private var email = ""
    @State private var password = ""
    @State private var message = ""
    @State private var isError = false
    @State private var goHome = false
    @State private var goAdmin = false
    @State private var showPassword = false
    
    let controller = AuthController()
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Spacer().frame(height: 40)
                
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.green.opacity(0.2))
                        .frame(width: 96, height: 96)
                    Image(systemName: "graduationcap.fill")
                        .font(.system(size: 36))
                        .foregroundColor(.green)
                }
                
                // Title
                VStack(spacing: 8) {
                    Text("Chào mừng trở lại!")
                        .font(.system(size: 28, weight: .bold))
                    Text("Đăng nhập để tiếp tục học nào.")
                        .foregroundColor(.gray)
                }
                
                // Form
                VStack(alignment: .leading, spacing: 16) {
                    // Email
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Email")
                        HStack {
                            Image(systemName: "envelope.fill")
                                .foregroundColor(.gray)
                            TextField("Nhập email của bạn", text: $email)
                                .keyboardType(.emailAddress)
                                .autocapitalization(.none)
                                .textInputAutocapitalization(.never)
                        }
                        .padding()
                        .background(Color(.green))
                        .cornerRadius(0)
                    }
                    
                    // Password
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Mật khẩu")
                        HStack(spacing: 12) {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.gray)
                            if showPassword {
                                TextField("Nhập mật khẩu", text: $password)
                            } else {
                                SecureField("Nhập mật khẩu", text: $password)
                            }
                            Button {
                                showPassword.toggle()
                            } label: {
                                Image(systemName: showPassword ? "eye.slash.fill" : "eye.fill")
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding()
                        .background(Color(.green))
                        .cornerRadius(0)
                    }
                }
                
                // Login Button
                Button {
                    controller.login(email: email, password: password) { err in
                        if let err = err {
                            isError = true
                            message = err
                            return
                        }
                        
                        isError = false
                        message = "Đăng nhập thành công!"
                        
                        controller.getRole { role in
                            DispatchQueue.main.async {
                                if let role = role {
                                    if role == 0 {
                                        goAdmin = true
                                    } else {
                                        goHome = true
                                    }
                                } else {
                                    message = "Không lấy được vai trò người dùng"
                                    isError = true
                                }
                            }
                        }
                    }
                } label: {
                    Text("Đăng nhập")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(18)
                        .shadow(color: Color.green.opacity(0.3), radius: 10, y: 6)
                }
                
                // Message
                Text(message)
                    .foregroundColor(isError ? .red : .green)
                
                // Register link
                HStack {
                    Text("Chưa có tài khoản?")
                        .foregroundColor(.gray)
                    NavigationLink {
                        RegisterView()
                    } label: {
                        Text("Đăng ký ngay")
                            .bold()
                            .foregroundColor(.green)
                    }
                }
                
                Spacer()
                
                // Hidden navigation links
                NavigationLink("", destination: HomeView().navigationBarBackButtonHidden(true), isActive: $goHome).hidden()
                NavigationLink("", destination: ManagerView().navigationBarBackButtonHidden(true), isActive: $goAdmin).hidden()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 30)
        }
    }
}

//struct LoginView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoginView()
//    }
//}

