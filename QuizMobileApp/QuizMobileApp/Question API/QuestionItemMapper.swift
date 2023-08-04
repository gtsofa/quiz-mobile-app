//
//  QuestionItemMapper.swift
//  QuizMobileApp
//
//  Created by Julius on 04/08/2023.
//

import Foundation

internal final class QuestionItemMapper {
    static var OK_200: Int { return 200 }
    
    internal static func map(_ data: Data, from response: HTTPURLResponse) throws -> [QuestionItem] {
        guard response.statusCode == OK_200, let item = try? JSONDecoder().decode(QuestionItem.self, from: data) else {
            throw RemoteQuestionLoader.Error.invalidData
        }
        
        return [item]
    }
}
