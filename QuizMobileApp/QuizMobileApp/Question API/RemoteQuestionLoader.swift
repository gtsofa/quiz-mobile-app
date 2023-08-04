//
//  RemoteQuestionLoader.swift
//  QuizMobileApp
//
//  Created by Julius on 31/07/2023.
//

import Foundation

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
        
        case success([QuestionItem])
        case failure(Error)
    }
    
    public func load(completion: @escaping (Result) -> Void ) {
        client.get(from: url) { [weak self] result in
            guard self != nil else { return }
            
            switch result {
            case let .success(data, response):
                completion(QuestionItemMapper.map(data, from: response))
                
            case .failure:
                completion(.failure(.connectivitiy))
            }
            
        }
    }
}



