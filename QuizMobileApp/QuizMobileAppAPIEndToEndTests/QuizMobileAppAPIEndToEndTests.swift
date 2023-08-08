//
//  QuizMobileAppAPIEndToEndTests.swift
//  QuizMobileAppAPIEndToEndTests
//
//  Created by Julius on 08/08/2023.
//

import XCTest
import QuizMobileApp

final class QuizMobileAppAPIEndToEndTests: XCTestCase {
    func test_endToEndTestServerGETQuestionResult_matchesFixedTestAccountData() {
        
        switch getResult() {
        case let .success(result)?:
            XCTAssertEqual(result.count, 1, "Expected 1 quiz question")
            XCTAssertEqual(result.first?.question, "What are all the java keywords?")
            XCTAssertEqual(result.first?.answer[0], answers(at: 0))
            XCTAssertEqual(result.first?.answer[1], answers(at: 1))
            XCTAssertEqual(result.first?.answer[2], answers(at: 2))
            XCTAssertEqual(result.first?.answer[3], answers(at: 3))
            XCTAssertEqual(result.first?.answer[4], answers(at: 4))
            XCTAssertEqual(result.first?.answer[5], answers(at: 5))
            XCTAssertEqual(result.first?.answer[6], answers(at: 6))
            XCTAssertEqual(result.first?.answer[7], answers(at: 7))
            XCTAssertEqual(result.first?.answer[8], answers(at: 8))
            XCTAssertEqual(result.first?.answer[9], answers(at: 9))
            XCTAssertEqual(result.first?.answer[10], answers(at: 10))
            XCTAssertEqual(result.first?.answer[11], answers(at: 11))
            XCTAssertEqual(result.first?.answer[12], answers(at: 12))
            XCTAssertEqual(result.first?.answer[13], answers(at: 13))
            XCTAssertEqual(result.first?.answer[14], answers(at: 14))
            XCTAssertEqual(result.first?.answer[15], answers(at: 15))
            XCTAssertEqual(result.first?.answer[16], answers(at: 16))
            XCTAssertEqual(result.first?.answer[17], answers(at: 17))
            XCTAssertEqual(result.first?.answer[18], answers(at: 18))
            XCTAssertEqual(result.first?.answer[19], answers(at: 19))
            XCTAssertEqual(result.first?.answer[20], answers(at: 20))
            XCTAssertEqual(result.first?.answer[21], answers(at: 21))
            XCTAssertEqual(result.first?.answer[22], answers(at: 22))
            XCTAssertEqual(result.first?.answer[23], answers(at: 23))
            XCTAssertEqual(result.first?.answer[24], answers(at: 24))
            XCTAssertEqual(result.first?.answer[25], answers(at: 25))
            XCTAssertEqual(result.first?.answer[26], answers(at: 26))
            XCTAssertEqual(result.first?.answer[27], answers(at: 27))
            XCTAssertEqual(result.first?.answer[28], answers(at: 28))
            XCTAssertEqual(result.first?.answer[29], answers(at: 29))
            XCTAssertEqual(result.first?.answer[30], answers(at: 30))
            XCTAssertEqual(result.first?.answer[31], answers(at: 31))
            XCTAssertEqual(result.first?.answer[32], answers(at: 32))
            XCTAssertEqual(result.first?.answer[33], answers(at: 33))
            XCTAssertEqual(result.first?.answer[34], answers(at: 34))
            XCTAssertEqual(result.first?.answer[35], answers(at: 35))
            XCTAssertEqual(result.first?.answer[36], answers(at: 36))
            XCTAssertEqual(result.first?.answer[37], answers(at: 37))
            XCTAssertEqual(result.first?.answer[38], answers(at: 38))
            XCTAssertEqual(result.first?.answer[39], answers(at: 39))
            XCTAssertEqual(result.first?.answer[40], answers(at: 40))
            XCTAssertEqual(result.first?.answer[41], answers(at: 41))
            XCTAssertEqual(result.first?.answer[42], answers(at: 42))
            XCTAssertEqual(result.first?.answer[43], answers(at: 43))
            XCTAssertEqual(result.first?.answer[44], answers(at: 44))
            XCTAssertEqual(result.first?.answer[45], answers(at: 45))
            XCTAssertEqual(result.first?.answer[46], answers(at: 46))
            XCTAssertEqual(result.first?.answer[47], answers(at: 47))
            XCTAssertEqual(result.first?.answer[48], answers(at: 48))
            XCTAssertEqual(result.first?.answer[49], answers(at: 49))
        case let .failure(error)?:
            XCTFail("Expected successful question result, got \(error) instead")
        default:
            XCTFail("Expected successful question result, got no result instead.")
        }
    }
    
    // MARK: - Helpers
    
    private func getResult(file: StaticString = #file, line: UInt = #line) -> LoadQuestionResult? {
        let client = URLSessionHTTPClient(session: URLSession(configuration: .ephemeral))
        let loader = RemoteQuestionLoader(url: quizTestServerURL , client: client)
        
        trackForMemoryLeak(client, file: file, line: line)
        trackForMemoryLeak(loader, file: file, line: line)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: LoadQuestionResult?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 3.0)
        
        return receivedResult
    }
    
    private var quizTestServerURL: URL {
        return URL(string: "https://raw.githubusercontent.com/mauriciomaniglia/quiz-mobile-app/master/quiz.api")!
    }
    
    func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
    
    private func answers(at index: Int) -> String? {
        return [
            "abstract",
            "assert",
            "boolean",
            "break",
            "byte",
            "case",
            "catch",
            "char",
            "class",
            "const",
            "continue",
            "default",
            "do",
            "double",
            "else",
            "enum",
            "extends",
            "final",
            "finally",
            "float",
            "for",
            "goto",
            "if",
            "implements",
            "import",
            "instanceof",
            "int",
            "interface",
            "long",
            "native",
            "new",
            "package",
            "private",
            "protected",
            "public",
            "return",
            "short",
            "static",
            "strictfp",
            "super",
            "switch",
            "synchronized",
            "this",
            "throw",
            "throws",
            "transient",
            "try",
            "void",
            "volatile",
            "while"
        ][index]
    }

}
