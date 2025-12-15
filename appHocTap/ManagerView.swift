//
//  ManagerView.swift
//  appHocTap
//
//  Created by  User on 15.12.2025.
//

import SwiftUI

struct ManagerView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    
                    // MARK: - Header
                    HStack {
                        Text("Trang Chủ Quản Trị")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        Image(systemName: "person.circle")
                            .font(.title2)
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Statistic Cards
                    HStack(spacing: 16) {
                        StatCard(
                            title: "Tổng số người dùng",
                            value: "1,234"
                        )
                        
                        StatCard(
                            title: "Tổng số câu hỏi",
                            value: "5,678"
                        )
                    }
                    .padding(.horizontal)
                    
                    // MARK: - Section Title
                    Text("Điều hướng chính")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    // MARK: - Navigation Buttons
                    NavigationStack {
                        HStack(spacing: 16) {
                            
                            NavigationLink {
                                QuestionListView()
                            } label: {
                                AdminActionCard(
                                    icon: "questionmark.square",
                                    title: "Quản lý Câu hỏi",
                                    subtitle: "Tạo, sửa, xóa câu hỏi"
                                )
                            }
                            
                            NavigationLink {
                                UserListView()
                            } label: {
                                AdminActionCard(
                                    icon: "person.2.fill",
                                    title: "Quản lý Người dùng",
                                    subtitle: "Xem và quản lý tài khoản"
                                )
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top)
                }
                
            }
        }
    }
}

//struct ManagerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ManagerView()
//    }
//}
