//
//  StartGameUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Julius on 10/08/2023.
//

import XCTest
import QuizMobileApp


class QuizGameEngine {
    private let counter: Counter
    
    init(counter: Counter) {
        self.counter = counter
    }
    
    enum Result: Equatable {
        case startGame
        case updateSecond(Int)
    }
    
    func startGame(completion: @escaping (Result) -> Void) {
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
    
    func test_startGame_doesNotDeliverResultAfterInstanceHasBeenDeallocated() {
        let counter = CounterSpy(seconds: 1)
        var sut: QuizGameEngine? = QuizGameEngine(counter: counter)
        
        var capturedResult = [QuizGameEngine.Result]()
        sut?.startGame { capturedResult.append($0)}
        
        sut = nil
        
        counter.startGameMessage()
        
        XCTAssertTrue(capturedResult.isEmpty)
    }
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: QuizGameEngine, counter: CounterSpy) {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter)
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(counter, file: file, line: line)
        
        return (sut, counter)
    }
    
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
    }

}
