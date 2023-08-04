//
//  QuestionLoader.swift
//  QuizMobileApp
//
//  Created by Julius on 31/07/2023.
//

import Foundation

public enum LoadQuestionResult<Error: Swift.Error> {
    case success([QuestionItem])
    case failure(Error)
}

extension LoadQuestionResult: Equatable where Error: Equatable {}

protocol QuestionLoader {
    associatedtype Error: Swift.Error
    
    func load(completion: @escaping (LoadQuestionResult<Error>) -> Void)
}
