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
    
    func test_add_deliversTheAddedAnswerOnSuccessfulSave() {
        let (sut, _) = makeSUT()
        
        var savedAnswer = [String]()
        sut.add("answer1") { savedAnswer = $0.savedAnswers }
        
        XCTAssertEqual(savedAnswer, ["answer1"])
    }
    
    func test_addTwice_addsTheTwoAddedAnswersOnSuccessfullySave() {
        let (sut, _) = makeSUT()
        
        var savedAnswers = [String]()
        sut.add("answer1") { savedAnswers = $0.savedAnswers }
        
        sut.add("answer2") { savedAnswers = $0.savedAnswers }
        
        XCTAssertEqual(savedAnswers, ["answer1", "answer2"])
    }
    
    func test_add_doesNotSaveEmptyAnswer() {
        let (sut, _) = makeSUT()
        
        var savedAnswers = [String]()
        sut.add("") { savedAnswers = $0.savedAnswers }
        
        XCTAssertEqual(savedAnswers, [])
    }
    
    func test_add_showsTheSavedAnswersInCorrectOrder() {
        let (sut, _) = makeSUT()
        
        var savedAnswers = [String]()
        sut.add("answer1") { savedAnswers = $0.savedAnswers }
        sut.add("answer2") { savedAnswers = $0.savedAnswers }
        sut.add("answer3") { savedAnswers = $0.savedAnswers }
        sut.add("") { savedAnswers = $0.savedAnswers }
        sut.add("answer4") { savedAnswers = $0.savedAnswers }
        
        XCTAssertEqual(savedAnswers, ["answer1", "answer2", "answer3", "answer4"])
    }
    
    func test_add_doesNotSaveAnswerWithEmptySpaces() {
        let (sut, _) = makeSUT()
        
        var savedAnswers = [String]()
        sut.add(" answer") {savedAnswers = $0.savedAnswers }
        sut.add("answer1 ") { savedAnswers = $0.savedAnswers }
        sut.add(" answer2 ") { savedAnswers = $0.savedAnswers }
        XCTAssertEqual(savedAnswers, ["answer", "answer1", "answer2"])
    }
    
    func test_add_doesNotSaveAnswerWithWhiteSpacesOnly() {
        let (sut, _) = makeSUT()
        
        var savedAnswers = [String]()
        sut.add(" ") {savedAnswers = $0.savedAnswers }
        
        XCTAssertEqual(savedAnswers, [])
    }
    
    // MARK:- Helpers
    
    private func makeSUT(file: StaticString = #filePath, line: UInt = #line) -> (sut: QuizGameEngine, counter: CounterSpy) {
        let counter = CounterSpy(seconds: 1)
        let sut = QuizGameEngine(counter: counter, correctAnswers: [])
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(counter, file: file, line: line)
        
        return (sut, counter)
    }

}
