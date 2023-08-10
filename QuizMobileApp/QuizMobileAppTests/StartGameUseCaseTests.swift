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
    
    func startGame() {
        counter.start()
    }
}

final class StartGameUseCaseTests: XCTestCase {

    func test_init_doesNotRequestToStartCounter() {
        let counter = CounterSpy()
        
        _ = QuizGameEngine(counter: counter)
        
        XCTAssertEqual(counter.startCounterCallCount, 0)
    }
    
    func test_startGame_startsTheCounter() {
        let counter = CounterSpy()
        let sut = QuizGameEngine(counter: counter)
        
        sut.startGame()
        
        XCTAssertEqual(counter.startCounterCallCount, 1)
    }
    
    class CounterSpy {
        var startCounterCallCount = 0
        
        func start() {
            startCounterCallCount += 1
        }
    }

}
