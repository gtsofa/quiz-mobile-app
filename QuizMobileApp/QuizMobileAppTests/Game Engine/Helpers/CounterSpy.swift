//
//  CounterSpy.swift
//  QuizMobileAppTests
//
//  Created by Julius on 14/08/2023.
//

import Foundation
import QuizMobileApp

class CounterSpy: Counter {
    var seconds = 0
    var messages = [CounterResult]()
    var completions: ((CounterResult) -> Void)?
    
    init(seconds: Int) {
        self.seconds = seconds
    }
    
    func start(completion: @escaping (CounterResult) -> Void) {
        guard seconds > 0 else { return }
        messages.append(.start)
        completions = completion
        
        while seconds > 0 {
            messages.append(.currentSecond(seconds))
            
            seconds -= 1
        }
    }
    
    public func stop() {
        completions?(.stop)
    }
    
    func startGameMessage(index: Int = 0) {
        completions?(.start)
    }
    
    func sendCurrentSecond(index: Int = 0) {
        completions?(.currentSecond(seconds))
    }
    
    func reset() {
        messages.append(.reset)
    }
    
    func sendStopMessage() {
        completions?(.stop)
    }
}
