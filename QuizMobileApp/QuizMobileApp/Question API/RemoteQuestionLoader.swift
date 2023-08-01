//
//  RemoteQuestionLoader.swift
//  QuizMobileApp
//
//  Created by Julius on 31/07/2023.
//

import Foundation

public protocol HTTPClient {
    func get(from url: URL, completion: @escaping (Error?, HTTPURLResponse?) -> Void)
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
    
    public func load(completion: @escaping (Error) -> Void ) {
        client.get(from: url) { error, response in
            if response != nil {
                completion(.invalidData)
            } else {
                completion(.connectivitiy)
            }
            
        }
    }
}

