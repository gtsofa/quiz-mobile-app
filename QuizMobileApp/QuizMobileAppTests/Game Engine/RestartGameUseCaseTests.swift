//
//  RestartGameUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Julius on 14/08/2023.
//

import XCTest
import QuizMobileApp

final class RestartGameUseCaseTests: XCTestCase {
    func test_init_doesNotRequestToRestartTheGame() {
        let (_, counter) = makeSUT()
        
        XCTAssertEqual(counter.messages.count, 0)
    }
    
    func test_restartGame_deletesSavedAnswer() {
        let (sut, _) = makeSUT()
        var savedAnswers = [String]()
        sut.add("answer") { savedAnswers = $0.savedAnswers}
        sut.add("answer1") { savedAnswers = $0.savedAnswers}
        
        sut.restartGame { _ in  }
        sut.add("answer2") { savedAnswers = $0.savedAnswers}
        XCTAssertEqual(savedAnswers, ["answer2"])
    }
    
    func test_restartGame_resetsCounter() {
        let (sut, counter) = makeSUT()
        
        sut.restartGame { _ in  }
        XCTAssertEqual(counter.messages, [.reset])
        
    }
    
    func test_restartGame_deliversRestartMessageWithCorrectAnswersCount() {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter, correctAnswers: ["answer1", "answer2"])
        
        let expectedMessage = ["correct_answers_count": 2]
        var receivedMessage = [String: Int]()
        sut.restartGame { result in
            receivedMessage = result
        }
        
        XCTAssertEqual(receivedMessage, expectedMessage)
    }
    
    func test_startGame_doesNotRequestToStartTheGameWithEmptyCorrectAnswers() {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter, correctAnswers: [])
        
        sut.startGame { _ in }
        XCTAssertEqual(counter.messages, [])
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
