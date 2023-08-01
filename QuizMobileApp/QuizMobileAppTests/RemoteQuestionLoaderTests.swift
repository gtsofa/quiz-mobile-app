//
//  RemoteQuestionLoaderTests.swift
//  QuizMobileAppTests
//
//  Created by Julius on 31/07/2023.
//

import XCTest
import QuizMobileApp

final class RemoteQuestionLoaderTests: XCTestCase {
    func test_init_doesNotLoadDataFromURL() {
        let (_, client) = makeSUT()
        
        XCTAssertEqual(client.requestedURLs, [])
    }
    
    func test_load_requestDataFromURL() {
        let url = URL(string: "http://a-given-url.com")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url])
    }
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "http://a-given-url.com")!
        
        let (sut, client) = makeSUT(url: url)
        
        sut.load()
        sut.load()
        
        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversErrorOnClientError() {
        let (sut, client) = makeSUT()
        
        var capturedErrors = [RemoteQuestionLoader.Error]()
        sut.load { capturedErrors.append($0)}
        
        let clientError = NSError(domain: "test", code: 0)
        client.completions[0](clientError)
        
        XCTAssertEqual(capturedErrors, [.connectivitiy])
    }
    
    // MARK: - Helpers
    
    private func makeSUT(url: URL = URL(string: "http://a-url.com")!) -> (sut: RemoteQuestionLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = RemoteQuestionLoader(url: url, client: client)
        return (sut, client)
    }
    
    class HTTPClientSpy: HTTPClient {
        var requestedURLs = [URL]()
        
        var completions = [(Error) -> Void]()
        
        
        func get(from url: URL, completion: @escaping (Error) -> Void) {
            completions.append(completion)
            requestedURLs.append(url)
            
        }
    }

}
