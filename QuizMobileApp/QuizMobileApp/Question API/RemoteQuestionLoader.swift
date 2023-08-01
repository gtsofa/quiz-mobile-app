//
//  RemoteQuestionLoader.swift
//  QuizMobileApp
//
//  Created by Julius on 31/07/2023.
//

import Foundation

public enum HTTPClientResult {
    case success(Data, HTTPURLResponse)
    case failure(Error)
}

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (HTTPClientResult) -> Void)
}

public class RemoteQuestionLoader {
    private let client: HTTPClient
    private let url: URL
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public enum Error: Swift.Error {
        case connectivitiy
        case invalidData
    }
    
    public enum Result: Equatable {
        
        case success(QuestionItem)
        case failure(Error)
    }
    
    public func load(completion: @escaping (Result) -> Void ) {
        client.get(from: url) { result in
            switch result {
            case .success:
                completion(.failure(.invalidData))
            case .failure:
                completion(.failure(.connectivitiy))
            }
            
        }
    }
}

