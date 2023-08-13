//
//  QuizGameEngine.swift
//  QuizMobileApp
//
//  Created by Julius on 12/08/2023.
//

import Foundation

public class QuizGameEngine {
    private let counter: Counter
    private var savedAnswers = [String]()
    private var correctAnswers = [String]()
    
    public init(counter: Counter, correctAnswers: [String]) {
        self.counter = counter
        self.correctAnswers = correctAnswers
    }
    
    public enum Result: Equatable {
        case startGame
        case updateSecond(Int)
    }
    
    public func startGame(completion: @escaping (Result) -> Void) {
        counter.start { [weak self] counterRessult in
            guard self != nil else { return }
            
            switch counterRessult {
            case .start:
                completion(.startGame)
            case let .currentSecond(second):
                completion(.updateSecond(second))
            }
        }
    }
    
    public func add(_ answer: String, completion: @escaping ([String]) -> Void) {
        guard !answer.isEmpty else { return }
        
        let trimmedAnswer = answer.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedAnswer.isEmpty else { return }
        savedAnswers.append(trimmedAnswer)
        
        completion(savedAnswers)
    }
}
