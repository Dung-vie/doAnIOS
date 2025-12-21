//
//  MyDatabase.swift
//  appHocTap
//
//  Created by  User on 21.12.2025.
//

import Firebase
import FirebaseDatabase

class MyDatabase {
    static let shared = MyDatabase()
    let dbRef: DatabaseReference

    private init() {
        dbRef = Database.database().reference()
    }

    func register(email: String,
                  password: String,
                  fullName: String,
                  completion: @escaping (Result<User, Error>) -> Void) {

        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let user = result?.user else {
                completion(.failure(
                    NSError(domain: "", code: -1,
                            userInfo: [NSLocalizedDescriptionKey: "Không lấy được user"])
                ))
                return
            }

            let profile = UserProfile(uid: user.uid, fullName: fullName, email: email)

            // Convert Model -> Dictionary
            if let data = try? JSONEncoder().encode(profile),
               let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {

                self.dbRef.child("users").child(user.uid).setValue(dict)
            }

            completion(.success(user))
        }
    }
}

	
