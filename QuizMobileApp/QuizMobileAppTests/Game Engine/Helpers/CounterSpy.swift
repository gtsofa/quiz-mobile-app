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
    var startCompletions = [(CounterResult) -> Void]()
    
    
    init(seconds: Int) {
        self.seconds = seconds
    }
    
    func start(completion: @escaping (CounterResult) -> Void) {
        guard seconds > 0 else { return }
        messages.append(.start)
        
        while seconds > 0 {
            startCompletions.append(completion)
            messages.append(.currentSecond(seconds))
            
            seconds -= 1
        }
    }
    
    func startGameMessage(index: Int = 0) {
        guard startCompletions.count > 0 else { return }
        startCompletions[index](.start)
    }
    
    func sendCurrentSecond(index: Int = 0) {
        guard startCompletions.count > 0 else { return }
        startCompletions[index](.currentSecond(seconds))
    }
    
    func reset() {
        messages.append(.reset)
    }
}
