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
    
    enum QuizGameEngineResult {
        case startGame
        case updateSecond(Int)
    }
    
    func startGame(completion: @escaping (QuizGameEngineResult) -> Void) {
        counter.start { counterRessult in
            switch counterRessult {
            case .start:
                completion(.startGame)
            case let .currentSecond(second):
                completion(.updateSecond(second))
            }
        }
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
        
        sut.startGame { _ in }
        
        XCTAssertEqual(counter.startCounterCallCount, 1)
    }
    
    func test_startGame_startsTimerWhenGameStarts() {
        let (sut, counter) = makeSUT()
        
        var counterStartMessage = 0
        sut.startGame { gameResult in
            switch gameResult {
            case .startGame:
                counterStartMessage += 1
            case .updateSecond:
                XCTFail("Expected game start message, got \(gameResult) instead")
            }
        }
        
        counter.startGameMessage()
        
        XCTAssertEqual(counterStartMessage, 1)
    }
    
    func test_startGame_doesNotDeliverCounterStartMessageTwiceWhenSecondsGreaterThanOne() {
        let counter = CounterSpy(seconds: 2)
        let sut = QuizGameEngine(counter: counter)
        
        var counterStartMessage = 0
        sut.startGame { gameResult in
            switch gameResult {
            case .startGame:
                counterStartMessage += 1
            case .updateSecond:
                XCTFail("Expected game start message, got \(gameResult) instead")
            }
        }
        
        counter.startGameMessage()
        
        XCTAssertEqual(counterStartMessage, 1)
    }
    
    func test_startGame_doesNotDeliverCounterStartMessageWithZeroSeconds() {
        let counter = CounterSpy(seconds: 0)
        let sut = QuizGameEngine(counter: counter)
        
        var counterStartMessage = 0
        sut.startGame { gameResult in
            switch gameResult {
            case .startGame:
                counterStartMessage += 1
            case .updateSecond:
                XCTFail("Expected game start message, got \(gameResult) instead")
            }
            
        }
        
        counter.startGameMessage()
        XCTAssertEqual(counterStartMessage, 0)
    }
    
    func test_startGame_deliversCounterCurrentSecondWhenSecondsIsGreaterThanZero() {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter)
        
        var currentSecondCounterResultCount = 0
        sut.startGame { gameResult in
            switch gameResult {
            case .startGame:
                XCTFail("Expected update second message, got \(gameResult) instead")
            case .updateSecond:
                currentSecondCounterResultCount += 1
            }
        }
        
        counter.sendCurrentSecond()
        
        XCTAssertEqual(currentSecondCounterResultCount, 1)
    }
    
    func test_startGame_deliversCurrentCounterSecondTwiceWhenSecondIsEqualToTwo() {
        let counter = CounterSpy(seconds: 2)
        let sut = QuizGameEngine(counter: counter)
        
        sut.startGame { _ in }
        
        XCTAssertEqual(counter.startCounterCallCount, 2)
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
        var messages = [(CounterResult) -> Void]()
        
        enum CounterResult {
            case start
            case currentSecond(Int)
        }
        
        
        init(seconds: Int) {
            self.seconds = seconds
        }
        
        func start(completion: @escaping (CounterResult) -> Void) {
            guard seconds > 0 else { return }
            
            while seconds > 0 {
                startCounterCallCount += 1
                messages.append(completion)
                
                seconds -= 1
            }
        }
        
        func startGameMessage(index: Int = 0) {
            guard messages.count > 0 else { return }
            messages[index](.start)
        }
        
        func sendCurrentSecond(index: Int = 0) {
            guard messages.count > 0 else { return }
            messages[index](.currentSecond(seconds))
        }
    }

}
