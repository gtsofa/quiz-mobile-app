//
//  QuizGameEngine.swift
//  QuizMobileApp
//
//  Created by Julius on 12/08/2023.
//

import Foundation

public class QuizGameEngine {
    private let counter: Counter
    
    public init(counter: Counter) {
        self.counter = counter
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
}
