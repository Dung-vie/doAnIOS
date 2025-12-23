//
//  AuthController.swift
//  appHocTap
//
//  Created by  User on 21.12.2025.
//
import FirebaseAuth

class AuthController {
    
    // Đăng nhập
        func login(email: String,
                   password: String,
                   completion: @escaping (String?) -> Void) {
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                if let error = error {
                    completion(error.localizedDescription)
                    return
                }
                completion(nil) // Thành công
            }
        }
        
        // Đăng ký
        func register(fullName: String,
                      email: String,
                      password: String,
                      grade: Int,
                      completion: @escaping (String?) -> Void) {
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                if let error = error {
                    completion(error.localizedDescription)
                    return
                }
                
                guard let user = result?.user else {
                    completion("Không lấy được user")
                    return
                }
                
                let profile = UserProfile(
                    uid: user.uid,
                    fullName: fullName,
                    email: email,
                    grade: grade,
                    role: 1  // 1 = học sinh, 0 = admin
                )
                
                MyDatabase.shared.saveUser(profile) { success in
                    completion(success ? nil : "Lỗi lưu thông tin người dùng")
                }
            }
        }
        
        // Lấy UID hiện tại
        func getCurrentUID() -> String? {
            Auth.auth().currentUser?.uid
        }
        
        // Lấy role của user hiện tại
        func getRole(completion: @escaping (Int?) -> Void) {
            guard let uid = getCurrentUID() else {
                completion(nil)
                return
            }
            MyDatabase.shared.getRole(for: uid) { role in
                completion(role)
            }
        }
        
        // Đăng xuất
        func logout() {
            do {
                try Auth.auth().signOut()
            } catch {
                print("Lỗi đăng xuất: \(error.localizedDescription)")
            }
        }
}


