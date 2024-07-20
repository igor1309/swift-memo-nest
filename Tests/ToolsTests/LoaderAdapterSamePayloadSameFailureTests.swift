//
//  LoaderAdapterSamePayloadSameFailureTests.swift
//
//
//  Created by Igor Malyarov on 20.07.2024.
//

import Tools
import XCTest

final class LoaderAdapterSamePayloadSameFailureTests: XCTestCase {
    
    func test_load_shouldDeliverFailureOnOriginalFailure() {
        
        let message = anyMessage()
        let (sut, originalLoader) = makeSUT()
        
        expect(sut, toCompleteWith: .failure(.init(message: message))) {
            
            originalLoader.complete(with: .failure(.init(message: message)))
        }
    }
    
    func test_load_shouldDeliverSuccessOnOriginalSuccess() {
        
        let (sut, originalLoader) = makeSUT()
        
        expect(sut, toCompleteWith: .success("Success: 13")) {
            
            originalLoader.complete(with: .success(13))
        }
    }
    
    func test_load_shouldNotDeliverResultOnInstanceDeallocation() {
        
        var sut: SUT?
        let originalLoader: OriginalLoader
        (sut, originalLoader) = makeSUT()
        var result: SUT.LoadResult?
        
        sut?.load("42") { result = $0 }
        sut = nil
        originalLoader.complete(with: .failure(.init(message: anyMessage())))
        
        XCTAssertNil(result)
    }
    
    // MARK: - Helpers
    
    private typealias OriginalLoader = Spy<String, Int, OriginalError>
    private typealias SUT = LoaderAdapter<OriginalLoader, String, String, OriginalError>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        adaptedLoader: SUT,
        originalLoader: OriginalLoader
    ) {
        let originalLoader = OriginalLoader()
        let sut = SUT(
            originalLoader: originalLoader,
            mapSuccess: { return "Success: \($0)" }
        )
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(originalLoader, file: file, line: line)
        
        return (sut, originalLoader)
    }
    
    private struct OriginalError: Error, Equatable {
        
        let message: String
    }
    
    private func expect(
        _ sut: SUT,
        with payload: String = anyMessage(),
        toCompleteWith expectedResult: SUT.LoadResult,
        on action: @escaping () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "Load completion")
        
        sut.load(payload) { receivedResult in
            
            switch (receivedResult, expectedResult) {
            case (.success(let receivedValue), .success(let expectedValue)):
                XCTAssertEqual(receivedValue, expectedValue, file: file, line: line)
                
            case (.failure(let receivedError), .failure(let expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)
                
            default:
                XCTFail("Expected result \(expectedResult) but got \(receivedResult) instead", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1)
    }
}
