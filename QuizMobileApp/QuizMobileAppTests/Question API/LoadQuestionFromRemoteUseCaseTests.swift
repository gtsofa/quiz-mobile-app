//
//  LoadQuestionFromRemoteUseCaseTests.swift
//  QuizMobileAppTests
//
//  Created by Julius on 31/07/2023.
//

import XCTest
import QuizMobileApp

final class LoadQuestionFromRemoteUseCaseTests: XCTestCase {
    func test_init_doesNotLoadDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "http://a-given-url.com")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "http://a-given-url.com")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load { _ in }
        sut.load { _ in }
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.connectivitiy), when: {
            let clientError = NSError(domain: "test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()
        let samples = [199, 201, 300, 400, 500]
        
        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: failure(.invalidData), when: {
                let json = Data(_: "{}".utf8)
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let invalidJSON = Data(_: "invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversNoItemOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()
        
        expect(sut, toCompleteWith: failure(.invalidData), when: {
            let emptyJSONList = Data(_: "{}".utf8)
            client.complete(withStatusCode: 200, data: emptyJSONList)
        })

    }
    
    func test_load_deliversItemOn200HTTPResponseWithJSONList() {
        let (sut, client) = makeSUT()
        let answer = ["answer1", "answer2"]
        let json = ["question": "a question",
                    "answer": answer] as [String : Any]
        let item1 = makeItem(question: "a question", answer: answer)
        
        expect(sut, toCompleteWith: .success([item1.model]), when: {
            let data = try! JSONSerialization.data(withJSONObject: json)
            client.complete(withStatusCode: 200, data: data)
        })
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: RemoteQuestionLoader? = RemoteQuestionLoader(url: url, client: client)
        
        var capturedResults = [RemoteQuestionLoader.Result]()
        sut?.load { capturedResults.append($0)}
        
        sut = nil
        
        let emptyData = Data(_: "{}".utf8)
        client.complete(withStatusCode: 200, data: emptyData)
        
        XCTAssertTrue(capturedResults.isEmpty)
        
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "http://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: RemoteQuestionLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteQuestionLoader(url: url, client: client)
        trackForMemoryLeak(sut, file: file, line: line)
        trackForMemoryLeak(client, file: file, line: line)
        return (sut, client)
    }
    
    private func failure(_ error: RemoteQuestionLoader.Error) -> RemoteQuestionLoader.Result {
        return .failure(error)
    }
    
    func makeItem(question: String, answer: [String]) -> (model: QuestionItem, json: [String: Any]) {
        let item = QuestionItem(question: question, answer: answer)
        let itemJSON = makeItemJSON(question: question, answer: answer)
        return (item, itemJSON)
    }
    
    func makeItemJSON(question: String, answer: [String]) -> [String: Any] {
        return ["question": question, "answer": answer]
    }
    
    private func expect(_ sut: RemoteQuestionLoader, toCompleteWith expectedResult: RemoteQuestionLoader.Result, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        
        let exp = expectation(description: "Wait for load completion")
        
        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)
                
            case let (.failure(receivedError as RemoteQuestionLoader.Error), .failure(expectedError as RemoteQuestionLoader.Error)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead.", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1.0)
        
    }
    
    class HTTPClientSpy: HTTPClient {
        private var messages = [(url: URL, completion: (HTTPClientResult) -> Void)]()
        
        var requestedURLs: [URL] {
            return messages.map {$0.url}
        }
       
        func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void) {
            messages.append((url, completion))
        }
        
        func complete(with error: Error, at index: Int = 0) {
            messages[index].completion(.failure(error))
        }
        
        func complete(withStatusCode code: Int, data: Data, at index: Int = 0) {
            let response = HTTPURLResponse(
                url: requestedURLs[index],
                statusCode: code,
                httpVersion: nil,
                headerFields: nil
            )!
            messages[index].completion(.success(data, response))
        }
    }

}
