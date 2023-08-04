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

protocol QuestionLoader {
    associatedtype Error: Swift.Error
    
    func load(completion: @escaping (LoadQuestionResult<Error>) -> Void)
}
