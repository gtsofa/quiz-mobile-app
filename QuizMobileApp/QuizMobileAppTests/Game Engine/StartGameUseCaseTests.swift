//
//  StartGameUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Julius on 10/08/2023.
//

import XCTest
import QuizMobileApp

final class StartGameUseCaseTests: XCTestCase {

    func test_init_doesNotRequestToStartCounter() {
        let (_, counter) = makeSUT()
        
        _ = QuizGameEngine(counter: counter, correctAnswers: [])
        
        XCTAssertEqual(counter.messages.count, 0)
    }
    
    func test_startGame_startsTheCounter() {
        let (sut, counter) = makeSUT()
        
        sut.startGame { _ in }
        
        XCTAssertEqual(counter.messages, [.start, .currentSecond(1)])
    }
    
    func test_startGame_startsTimerWhenGameStarts() {
        let (sut, counter) = makeSUT()
        
        var messages = [QuizGameEngine.Result]()
        sut.startGame { gameResult in
            switch gameResult {
            case .startGame:
                messages.append(.startGame)
            case .updateSecond:
                messages.append(.updateSecond(1))
            }
        }
        
        counter.startGameMessage()
        
        XCTAssertEqual(messages, [.startGame])
    }
    
    func test_startGame_doesNotDeliverCounterStartMessageTwiceWhenSecondsGreaterThanOne() {
        let counter = CounterSpy(seconds: 2)
        let sut = QuizGameEngine(counter: counter, correctAnswers: [])
        
        var messages = [QuizGameEngine.Result]()
        sut.startGame { gameResult in
            switch gameResult {
            case .startGame:
                messages.append(.startGame)
            case .updateSecond:
                messages.append(.updateSecond(2))
            }
        }
        
        counter.startGameMessage()
        
        XCTAssertEqual(messages, [.startGame])
    }
    
    func test_startGame_doesNotDeliverCounterStartMessageWithZeroSeconds() {
        let counter = CounterSpy(seconds: 0)
        let sut = QuizGameEngine(counter: counter, correctAnswers: [])
        
        var messages = [QuizGameEngine.Result]()
        sut.startGame { gameResult in
            switch gameResult {
            case .startGame:
                messages.append(.startGame)
            case .updateSecond:
                messages.append(.updateSecond(1))
            }
            
        }
        
        counter.startGameMessage()
        XCTAssertEqual(messages, [])
    }
    
    func test_startGame_requestCounterCurrentSecondWhenSecondsIsGreaterThanZero() {
        let (sut, counter) = makeSUT()
        
        sut.startGame { _ in }
        
        XCTAssertEqual(counter.messages, [.start, .currentSecond(1)])
    }
    
    func test_startGame_requestCurrentCounterSecondTwiceWhenSecondIsEqualToTwo() {
        let counter = CounterSpy(seconds: 2)
        let sut = QuizGameEngine(counter: counter, correctAnswers: [])
        
        sut.startGame { _ in }
        
        XCTAssertEqual(counter.messages, [.start, .currentSecond(2), .currentSecond(1)])
    }
    
    func test_startGame_doesNotDeliverResultAfterInstanceHasBeenDeallocated() {
        let counter = CounterSpy(seconds: 1)
        var sut: QuizGameEngine? = QuizGameEngine(counter: counter, correctAnswers: [])
        
        var capturedResult = [QuizGameEngine.Result]()
        sut?.startGame { capturedResult.append($0)}
        
        sut = nil
        
        counter.startGameMessage()
        
        XCTAssertTrue(capturedResult.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: QuizGameEngine, counter: CounterSpy) {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter, correctAnswers: [])
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(counter, file: file, line: line)
        
        return (sut, counter)
    }
}

