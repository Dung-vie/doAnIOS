//
//  appHocTapApp.swift
//  appHocTap
//
//  Created by  User on 12.12.2025.
//

import SwiftUI
import Firebase

@main
struct appHocTapApp: App {
    init() {
        FirebaseApp.configure()
        print("Ket noi CSDL thanh cong")
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                LoginView()
            }
        }
    }
}
