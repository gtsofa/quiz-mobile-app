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
        
        case success([QuestionItem])
        case failure(Error)
    }
    
    public func load(completion: @escaping (Result) -> Void ) {
        client.get(from: url) { result in
            switch result {
            case let .success(data, response):
                completion(RemoteQuestionLoader.map(data, response: response))
                
            case .failure:
                completion(.failure(.connectivitiy))
            }
            
        }
    }
    
    private static func map(_ data: Data, response: HTTPURLResponse) -> Result {
        do {
            let items = try QuestionItemMapper.map(data, response: response)
            return .success(items)
            
        } catch {
            return .failure(error as! RemoteQuestionLoader.Error)
        }
    }
}

private class QuestionItemMapper {
    static func map(_ data: Data, response: HTTPURLResponse) throws -> [QuestionItem] {
        guard response.statusCode == 200, let item = try? JSONDecoder().decode(QuestionItem.self, from: data) else {
            throw RemoteQuestionLoader.Error.invalidData
        }
        
        return [item]
    }
}



