//
//  QuestionLoader.swift
//  QuizMobileApp
//
//  Created by Julius on 31/07/2023.
//

import Foundation

enum QuestionLoaderResult {
    case success([QuestionItem])
    case error(Error)
}

protocol QuestionLoader {
    func load(completion: @escaping (QuestionLoaderResult) -> Void)
}
