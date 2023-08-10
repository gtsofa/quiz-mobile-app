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
}

final class StartGameUseCaseTests: XCTestCase {

    func test_init_doesNotRequestToStartCounter() {
        let counter = CounterSpy()
        let sut = QuizGameEngine(counter: counter)
        XCTAssertEqual(counter.startCounterCallCount, 0)
    }
    
    class CounterSpy {
        var startCounterCallCount = 0
    }

}
