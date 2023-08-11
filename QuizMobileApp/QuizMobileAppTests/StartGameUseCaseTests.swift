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
        let (_, counter) = makeSUT()
        
        _ = QuizGameEngine(counter: counter)
        
        XCTAssertEqual(counter.startCounterCallCount, 0)
    }
    
    func test_startGame_startsTheCounter() {
        let (sut, counter) = makeSUT()
        
        sut.startGame { }
        
        XCTAssertEqual(counter.startCounterCallCount, 1)
    }
    
    func test_startGame_startsTimerWhenGameStarts() {
        let (sut, counter) = makeSUT()
        
        var counterStartMessage = 0
        sut.startGame {
            counterStartMessage += 1
        }
        
        counter.startGameMessage()
        
        XCTAssertEqual(counterStartMessage, 1)
    }
    
    func test_startGame_doesNotDeliverCounterStartMessageTwiceWhenSecondsGreaterThanOne() {
        let counter = CounterSpy(seconds: 2)
        let sut = QuizGameEngine(counter: counter)
        
        var counterStartMessage = 0
        sut.startGame {
            counterStartMessage += 1
        }
        
        counter.startGameMessage()
        
        XCTAssertEqual(counterStartMessage, 1)
    }
    
    func test_startGame_doesNotDeliverCounterStartMessageWithZeroSeconds() {
        let counter = CounterSpy(seconds: 0)
        let sut = QuizGameEngine(counter: counter)
        
        var counterStartMessage = 0
        sut.startGame {
            counterStartMessage += 1
        }
        
        XCTAssertEqual(counterStartMessage, 0)
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: QuizGameEngine, counter: CounterSpy) {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter)
        
        return (sut, counter)
    }
    
    class CounterSpy {
        var startCounterCallCount = 0
        var seconds = 0
        var messages = [() -> Void]()
        
        init(seconds: Int) {
            self.seconds = seconds
        }
        
        func start(completion: @escaping () -> Void) {
            if seconds > 0 {
                startCounterCallCount += 1
                messages.append(completion)
            }
        }
        
        func startGameMessage(index: Int = 0) {
            guard messages.count > 0 else { return }
            messages[index]()
        }
    }

}
