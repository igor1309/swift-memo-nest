//
//  AnyLoaderTests.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Tools
import XCTest

final class AnyLoaderTests: XCTestCase {
    
    func test_init_shouldNotCallLoad() {
        
        var loadCallCount = 0
        let _ = AnyLoader<Int, String, Error> { _, _ in
            loadCallCount += 1
        }
        XCTAssertEqual(loadCallCount, 0)
    }
    
    func test_load_shouldCallLoadWithPayload() {
        
        var receivedPayload: Int?
        let sut = AnyLoader<Int, String, Error> { payload, _ in
            receivedPayload = payload
        }
        
        let payload = 42
        sut.load(payload) { _ in }
        
        XCTAssertEqual(receivedPayload, payload)
    }
    
    func test_load_shouldCallLoadWithCompletion() {
        
        var receivedCompletion: ((Result<String, Error>) -> Void)?
        let sut = AnyLoader<Int, String, Error> { _, completion in
            receivedCompletion = completion
        }
        
        sut.load(42) { _ in }
        
        XCTAssertNotNil(receivedCompletion)
    }
    
    func test_load_shouldCompleteWithSuccess() {
        
        let expectedResult: Result<String, Error> = .success("Success")
        var capturedResult: Result<String, Error>?
        
        let sut = AnyLoader<Int, String, Error> { _, completion in
            completion(expectedResult)
        }
        
        sut.load(42) { result in
            capturedResult = result
        }
        
        switch (capturedResult, expectedResult) {
        case (.success(let capturedValue), .success(let expectedValue)):
            XCTAssertEqual(capturedValue, expectedValue)
        default:
            XCTFail("Expected success but got \(String(describing: capturedResult))")
        }
    }
    
    func test_load_shouldCompleteWithFailure() {
        
        let expectedResult: Result<String, Error> = .failure(TestError.someError)
        var capturedResult: Result<String, Error>?
        
        let sut = AnyLoader<Int, String, Error> { _, completion in
            completion(expectedResult)
        }
        
        sut.load(42) { result in
            capturedResult = result
        }
        
        switch (capturedResult, expectedResult) {
        case (.failure(let capturedError as TestError), .failure(let expectedError as TestError)):
            XCTAssertEqual(capturedError, expectedError)
        default:
            XCTFail("Expected failure but got \(String(describing: capturedResult))")
        }
    }
    
    func test_voidPayloadLoader_shouldCallLoadWithoutPayload() {
        
        var loadCallCount = 0
        let sut = AnyLoader<Void, String, Error> { completion in
            loadCallCount += 1
            completion(.success("Success"))
        }
        
        sut.load(()) { _ in }
        
        XCTAssertEqual(loadCallCount, 1)
    }
    
    func test_voidPayloadLoader_shouldCompleteWithSuccess() {
        
        let expectedResult: Result<String, Error> = .success("Success")
        var capturedResult: Result<String, Error>?
        
        let sut = AnyLoader<Void, String, Error> { completion in
            completion(expectedResult)
        }
        
        sut.load(()) { result in
            capturedResult = result
        }
        
        switch (capturedResult, expectedResult) {
        case (.success(let capturedValue), .success(let expectedValue)):
            XCTAssertEqual(capturedValue, expectedValue)
        default:
            XCTFail("Expected success but got \(String(describing: capturedResult))")
        }
    }
    
    func test_voidPayloadLoader_shouldCompleteWithFailure() {
        
        let expectedResult: Result<String, Error> = .failure(TestError.someError)
        var capturedResult: Result<String, Error>?
        
        let sut = AnyLoader<Void, String, Error> { completion in
            completion(expectedResult)
        }
        
        sut.load(()) { result in
            capturedResult = result
        }
        
        switch (capturedResult, expectedResult) {
        case (.failure(let capturedError as TestError), .failure(let expectedError as TestError)):
            XCTAssertEqual(capturedError, expectedError)
        default:
            XCTFail("Expected failure but got \(String(describing: capturedResult))")
        }
    }
    
    // MARK: - Helpers
    
    private enum TestError: Error {
        
        case someError
    }
}
