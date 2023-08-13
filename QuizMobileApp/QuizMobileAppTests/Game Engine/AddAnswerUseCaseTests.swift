//
//  AddAnswerUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Julius on 12/08/2023.
//

import XCTest
import QuizMobileApp

final class AddAnswerUseCaseTests: XCTestCase {
    func test_init_doesNotAddAnswer() {
        let (_, counter) = makeSUT()

        XCTAssertEqual(counter.messages.count, 0)
    }
    
    // MARK:- Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: QuizGameEngine, counter: CounterSpy) {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter)
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(counter, file: file, line: line)
        
        return (sut, counter)
    }

}
