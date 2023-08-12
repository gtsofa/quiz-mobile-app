//
//  Counter.swift
//  QuizMobileApp
//
//  Created by Julius on 12/08/2023.
//

import Foundation

public enum CounterResult: Equatable {
    case start
    case currentSecond(Int)
}

public protocol Counter {
    func start(completion: @escaping (CounterResult) -> Void)
}
