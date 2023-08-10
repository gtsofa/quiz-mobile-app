//
//  XCTestCase+MemoryLeakTracking.swift
//  QuizMobileAppTests
//
//  Created by Julius on 07/08/2023.
//


import XCTest

extension XCTestCase {
    func trackForMemoryLeak(_ instance: AnyObject, file: StaticString = #filePath, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should have been deallocated. Potential memory leak.", file: file, line: line)
        }
    }
}
