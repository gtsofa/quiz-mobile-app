//
//  QuestionItemMapper.swift
//  QuizMobileApp
//
//  Created by Julius on 04/08/2023.
//

import Foundation

internal final class QuestionItemMapper {
    static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse)  -> RemoteQuestionLoader.Result {
        guard response.statusCode == OK_200,
                let item = try? JSONDecoder().decode(QuestionItem.self, from: data) else {
            return .failure(RemoteQuestionLoader.Error.invalidData)
        }
        
        return .success([item])
    }
}
