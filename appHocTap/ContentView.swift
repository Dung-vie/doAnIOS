//
//  ContentView.swift
//  appHocTap
//
//  Created by  User on 12.12.2025.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                NavigationLink( destination: Text("ManagerView")) {
                    Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                    Text("may im")
                }
                
            }
            .padding()
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
