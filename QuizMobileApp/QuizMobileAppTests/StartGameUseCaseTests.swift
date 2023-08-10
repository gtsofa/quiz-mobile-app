//
//  StartGameUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Julius on 10/08/2023.
//

import XCTest

class QuizGameEngine {
    private let counter: StartGameUseCaseTests.CounterSpy
    
    init(counter: StartGameUseCaseTests.CounterSpy) {
        self.counter = counter
    }
    
    func startGame(completion: @escaping () -> Void) {
        counter.start(completion: completion)
    }
}

final class StartGameUseCaseTests: XCTestCase {

    func test_init_doesNotRequestToStartCounter() {
        let counter = CounterSpy(seconds: 1)
        
        _ = QuizGameEngine(counter: counter)
        
        XCTAssertEqual(counter.startCounterCallCount, 0)
    }
    
    func test_startGame_startsTheCounter() {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter)
        
        sut.startGame { }
        
        XCTAssertEqual(counter.startCounterCallCount, 1)
    }
    
    func test_startGame_startsTimerWhenGameStarts() {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter)
        
        var counterStartMessage = 0
        sut.startGame {
            counterStartMessage += 1
        }
        
        counter.startGameMessage()
        
        XCTAssertEqual(counterStartMessage, 1)
    }
    
    class CounterSpy {
        var startCounterCallCount = 0
        var seconds = 0
        var messages = [() -> Void]()
        
        init(seconds: Int) {
            self.seconds = seconds
        }
        
        func start(completion: @escaping () -> Void) {
            startCounterCallCount += 1
            messages.append(completion)
        }
        
        func startGameMessage(index: Int = 0) {
            messages[index]()
        }
    }

}
