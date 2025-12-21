//
//  AuthController.swift
//  appHocTap
//
//  Created by  User on 21.12.2025.
//

class AuthController {
    
    func register(fullName: String,
                  email: String,
                  password: String,
                  completion: @escaping (String?) -> Void) {
        
        if fullName.isEmpty || email.isEmpty || password.isEmpty {
            completion("Vui lòng nhập đầy đủ thông tin")
            return
        }
        
        if password.count < 6 {
            completion("Mật khẩu phải ≥ 6 ký tự")
            return
        }

        MyDatabase.shared.register(email: email,
                                   password: password,
                                   fullName: fullName) { result in
            
            switch result {
            case .success(_):
                completion(nil)
            case .failure(let err):
                completion(err.localizedDescription)
            }
        }
    }
}


