//
//  RemoteQuestionLoaderTests.swift
//  QuizMobileAppTests
//
//  Created by Julius on 31/07/2023.
//

import XCTest

class RemoteQuestionLoader {
    
}

class HTTPClient {
    var requestedURL: URL?
}

final class RemoteQuestionLoaderTests: XCTestCase {
    func test_init_doesNotLoadDataFromURL() {
        let client = HTTPClient()
        _ = RemoteQuestionLoader()
        
        XCTAssertNil(client.requestedURL)
    }

}
