//
//  QuestionItem.swift
//  QuizMobileApp
//
//  Created by Julius on 31/07/2023.
//

import Foundation

public struct QuestionItem: Equatable {
    public let question: String
    public let answer: [String]
    
    public init(question: String, answer: [String]) {
        self.question = question
        self.answer = answer
    }
}

extension QuestionItem: Decodable {
    
}


