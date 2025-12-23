//
//  RegisterView.swift
//  appHocTap
//
//  Created by  User on 15.12.2025.
//

import SwiftUI

struct RegisterView: View {
    @State private var fullName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var grade = 0
    @State private var message = ""
    @State private var isError = false
    
    let controller = AuthController()
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer().frame(height: 40)
            
            // Title
            VStack(spacing: 8) {
                Text("Tạo tài khoản")
                    .font(.system(size: 28, weight: .bold))
                Text("Bắt đầu hành trình học tập của bạn!")
                    .font(.system(size: 16))
                    .foregroundColor(.gray)
            }
            
            Spacer().frame(height: 20)
            
            // Form
            VStack(alignment: .leading, spacing: 16) {
                // Họ và tên
                VStack(alignment: .leading, spacing: 6) {
                    Text("Họ và tên")
                    TextField("Nhập họ và tên", text: $fullName)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(14)
                }
                
                // Email
                VStack(alignment: .leading, spacing: 6) {
                    Text("Email")
                    TextField("Nhập email", text: $email)
                        .keyboardType(.emailAddress)
                        .textInputAutocapitalization(.never)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(14)
                }
                
                // Mật khẩu
                VStack(alignment: .leading, spacing: 6) {
                    Text("Mật khẩu")
                    SecureField("Nhập mật khẩu", text: $password)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(14)
                }
                
                // Grade (có thể thay bằng Picker sau)
                VStack(alignment: .leading, spacing: 6) {
                    Text("Lớp")
                    TextField("Nhập lớp (ví dụ: 10)", value: $grade, format: .number)
                        .keyboardType(.numberPad)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(14)
                }
            }
            
            Spacer().frame(height: 24)
            
            // Register Button
            Button {
                if fullName.isEmpty || email.isEmpty || password.isEmpty {
                    message = "Vui lòng điền đầy đủ thông tin"
                    isError = true
                    return
                }
                
                controller.register(
                    fullName: fullName,
                    email: email,
                    password: password,
                    grade: grade
                ) { err in
                    DispatchQueue.main.async {
                        if let err = err {
                            message = err
                            isError = true
                        } else {
                            message = "Đăng ký thành công! Vui lòng đăng nhập."
                            isError = false
                        }
                    }
                }
            } label: {
                Text("Đăng ký")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(14)
            }
            
            Text(message)
                .foregroundColor(isError ? .red : .green)
            
            // Login link
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
