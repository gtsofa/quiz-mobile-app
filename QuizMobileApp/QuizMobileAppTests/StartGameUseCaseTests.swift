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
    
    enum Result: Equatable {
        case startGame
        case updateSecond(Int)
    }
    
    func startGame(completion: @escaping (Result) -> Void) {
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
        let sut = QuizGameEngine(counter: counter)
        
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
        let sut = QuizGameEngine(counter: counter)
        
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
        let sut = QuizGameEngine(counter: counter)
        
        sut.startGame { _ in }
        
        XCTAssertEqual(counter.messages, [.start, .currentSecond(2), .currentSecond(1)])
    }
    
    // MARK: - Helpers
    
    private func makeSUT() -> (sut: QuizGameEngine, counter: CounterSpy) {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter)
        
        return (sut, counter)
    }
    
    class CounterSpy {
        var seconds = 0
        var messages = [CounterResult]()
        var startCompletions = [(CounterResult) -> Void]()
        
        enum CounterResult: Equatable {
            case start
            case currentSecond(Int)
        }
        
        
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
    }

}
