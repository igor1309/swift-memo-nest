//
//  LoaderTests.swift
//  
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Tools
import XCTest

final class LoaderTests: XCTestCase {
    
    func test_voidPayloadLoader_load_callsCompletion() {
        
        let loader = VoidPayloadLoader()
        let expectedResult: Result<String, TestError> = .success("Success")
        var capturedResult: Result<String, TestError>?
        
        let exp = expectation(description: "wait for completion")
        loader.load { result in
            capturedResult = result
            exp.fulfill()
        }
        loader.complete(with: expectedResult)
        
        wait(for: [exp], timeout: 1.0)
        
        switch capturedResult {
        case .success(let success):
            XCTAssertEqual(success, "Success")
        default:
            XCTFail("Expected success but got \(String(describing: capturedResult))")
        }
    }
    
    func test_nonVoidPayloadLoader_load_callsCompletion() {
        
        let loader = NonVoidPayloadLoader()
        let expectedResult: Result<String, TestError> = .success("Success")
        var capturedResult: Result<String, TestError>?
        
        let exp = expectation(description: "wait for completion")
        loader.load("testPayload") { result in
            capturedResult = result
            exp.fulfill()
        }
        loader.complete(with: expectedResult)
        
        wait(for: [exp], timeout: 1.0)
        
        switch capturedResult {
        case .success(let success):
            XCTAssertEqual(success, "Success")
        default:
            XCTFail("Expected success but got \(String(describing: capturedResult))")
        }
    }
    
    // MARK: - Helpers
    
    private enum TestError: Error {
        
        case someError
    }
    
    private class VoidPayloadLoader: Loader {
        
        typealias Payload = Void
        typealias Success = String
        typealias Failure = TestError
        
        private var completions = [(Result<Success, Failure>) -> Void]()
        
        func load(_ payload: Void, _ completion: @escaping (Result<Success, Failure>) -> Void) {
            completions.append(completion)
        }
        
        func complete(with result: Result<Success, Failure>, at index: Int = 0) {
            completions[index](result)
        }
    }
    
    private class NonVoidPayloadLoader: Loader {
        
        typealias Payload = String
        typealias Success = String
        typealias Failure = TestError
        
        private var completions = [(Result<Success, Failure>) -> Void]()
        private(set) var loadedPayloads = [Payload]()
        
        func load(_ payload: Payload, _ completion: @escaping (Result<Success, Failure>) -> Void) {
            loadedPayloads.append(payload)
            completions.append(completion)
        }
        
        func complete(with result: Result<Success, Failure>, at index: Int = 0) {
            completions[index](result)
        }
    }
}
