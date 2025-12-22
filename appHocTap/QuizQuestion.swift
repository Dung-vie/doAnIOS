//
//  QuizQuestion.swift
//  appHocTap
//
//  Created by  User on 22.12.2025.
//

import Foundation

struct QuizQuestion: Identifiable, Equatable {
    let id: String
    let questionText: String
    let optionA: String
    let optionB: String
    let optionC: String
    let optionD: String
    let correctIndex: Int
    let explanation: String?

    var options: [String] { [optionA, optionB, optionC, optionD] }

    func optionText(for index: Int) -> String {
        let labels = ["A", "B", "C", "D"]
        let safe = (0..<options.count).contains(index) ? options[index] : ""
        return "\(labels.indices.contains(index) ? labels[index] : "?"). \(safe)"
    }
}
