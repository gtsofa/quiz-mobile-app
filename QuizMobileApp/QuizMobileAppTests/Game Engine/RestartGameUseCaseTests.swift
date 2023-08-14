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
    
    // MARK: - Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: QuizGameEngine, counter: CounterSpy) {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter, correctAnswers: [])
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(counter, file: file, line: line)
        
        return (sut, counter)
    }

}
