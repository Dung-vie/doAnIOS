//
//  QuestionRow.swift
//  appHocTap
//
//  Created by  User on 15.12.2025.
//

import SwiftUI

struct QuestionRow: View {
    let title: String
       let answers: [String]

       var body: some View {
           VStack(alignment: .leading, spacing: 8) {
               Text(title)
                   .font(.headline)

               ForEach(answers, id: \.self) {
                   Text($0)
                       .font(.caption)
               }

               HStack {
                   Spacer()
                   Image(systemName: "pencil")
                   Image(systemName: "trash")
                       .foregroundColor(.red)
               }
           }
           .padding()
           .background(Color(.systemGray6))
           .cornerRadius(12)
       }
}

struct FilterChip: View {
    let title: String
    var body: some View {
        Text(title)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(Color.green.opacity(0.2))
            .cornerRadius(20)
    }
}

//struct QuestionRow_Previews: PreviewProvider {
//    static var previews: some View {
//        QuestionRow()
//    }
//}
