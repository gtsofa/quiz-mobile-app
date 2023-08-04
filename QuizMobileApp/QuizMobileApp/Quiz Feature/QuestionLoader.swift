//
//  QuestionLoader.swift
//  QuizMobileApp
//
//  Created by Julius on 31/07/2023.
//

import Foundation

public enum LoadQuestionResult {
    case success([QuestionItem])
    case failure(Error)
}

protocol QuestionLoader {
    func load(completion: @escaping (LoadQuestionResult) -> Void)
}
