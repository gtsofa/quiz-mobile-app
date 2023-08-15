//
//  ValidateAnswersUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Julius on 15/08/2023.
//

import XCTest
import QuizMobileApp

final class ValidateAnswersUseCaseTests: XCTestCase {
    func test_startGame_deliversGameFinishedMessageWhenTotalGivenAnswersMatchesCorrectAnswers() {
        let counter = CounterSpy(seconds: 2)
        let sut = QuizGameEngine(counter: counter, correctAnswers: ["answer", "answer1", "answer2"])
        
        var receivedMessages = [QuizGameEngine.Result]()
        sut.startGame { receivedMessages.append($0)}
        
        sut.add("answer") { _ in }
        sut.add("answer1") { _ in }
        sut.add("answer2") { _ in }
        
        XCTAssertEqual(receivedMessages, [.gameFinished])
    }

}
