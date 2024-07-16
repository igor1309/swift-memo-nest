//
//  StrategyLoaderTests.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

import XCTest
import Tools

final class StrategyLoaderTests: XCTestCase {
    
    func test_init_shouldNotCallCollaborators() {
        
        let (_, primary, secondary) = makeSUT()
        
        XCTAssertEqual(primary.callCount, 0)
        XCTAssertEqual(secondary.callCount, 0)
    }
    
    func test_load_callsPrimaryLoaderWithPayload() {
        
        let payload = "testPayload"
        let (sut, primaryLoader, _) = makeSUT()
        
        sut.load(payload) { _ in }
        
        XCTAssertNoDiff(primaryLoader.payloads, [payload])
    }
    
    func test_load_callsSecondaryLoaderOnPrimaryFailure() {
        
        let payload = "testPayload"
        let primaryFailure = anyFailure()
        let (sut, primaryLoader, secondaryLoader) = makeSUT()
        
        sut.load(payload) { _ in }
        primaryLoader.complete(with: .failure(primaryFailure))
        
        XCTAssertNoDiff(secondaryLoader.payloads, [payload])
    }
    
    func test_load_doesNotCallSecondaryLoaderOnPrimarySuccess() {
        
        let payload = "testPayload"
        let primarySuccess = "success"
        let (sut, primaryLoader, secondaryLoader) = makeSUT()
        
        assert(sut, with: payload, toDeliver: .success(primarySuccess)) {
            
            primaryLoader.complete(with: .success(primarySuccess))
        }
        
        XCTAssertNoDiff(secondaryLoader.callCount, 0)
    }
    
    func test_load_deliversPrimarySuccess() {
        
        let payload = "testPayload"
        let primarySuccess = "success"
        let (sut, primaryLoader, _) = makeSUT()
        
        assert(sut, with: payload, toDeliver: .success(primarySuccess)) {
            
            primaryLoader.complete(with: .success(primarySuccess))
        }
    }
    
    func test_load_deliversSecondarySuccessOnPrimaryFailure() {
        
        let payload = "testPayload"
        let primaryFailure = NSError(domain: "test", code: 1, userInfo: nil)
        let secondarySuccess = "success"
        let (sut, primaryLoader, secondaryLoader) = makeSUT()
        
        assert(sut, with: payload, toDeliver: .success(secondarySuccess)) {
            
            primaryLoader.complete(with: .failure(primaryFailure))
            secondaryLoader.complete(with: .success(secondarySuccess))
        }
    }
    
    func test_load_deliversSecondaryFailureOnPrimaryFailure() {
        
        let payload = "testPayload"
        let primaryFailure = NSError(domain: "test", code: 1, userInfo: nil)
        let secondaryFailure = anyFailure()
        let (sut, primaryLoader, secondaryLoader) = makeSUT()
        
        assert(sut, with: payload, toDeliver: .failure(secondaryFailure)) {
            
            primaryLoader.complete(with: .failure(primaryFailure))
            secondaryLoader.complete(with: .failure(secondaryFailure))
        }
    }
    
    func test_load_shouldNotCallCompletionOnInstanceDeallocation() {
        
        var sut: SUT? = makeSUT().sut
        let primaryLoader: Primary
        (sut, primaryLoader, _) = makeSUT()
        var capturedResult: SUT.LoadResult?
        
        sut?.load("testPayload") { capturedResult = $0 }
        
        sut = nil
        primaryLoader.complete(with: .failure(NSError(domain: "test", code: 1, userInfo: nil)))
        
        XCTAssertNil(capturedResult)
    }
    
    // MARK: - Helpers
    
    private typealias SUT = StrategyLoader<String, String, Failure>
    private typealias Primary = Spy<String, String, Error>
    private typealias Secondary = Spy<String, String, Failure>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: SUT,
        primary: Primary,
        secondary: Secondary
    ) {
        let primary = Primary()
        let secondary = Secondary()
        let sut = SUT(
            primary: primary,
            secondary: secondary
        )
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(primary, file: file, line: line)
        trackForMemoryLeaks(secondary, file: file, line: line)
        
        return (sut, primary, secondary)
    }
    
    private struct Failure: Error, Equatable {
        
        let value: String
    }
    
    private func anyFailure(
        _ value: String = UUID().uuidString
    ) -> Failure {
        
        return .init(value: value)
    }
    
    private func assert(
        _ sut: SUT,
        with payload: String,
        toDeliver expectedResult: SUT.LoadResult,
        on action: @escaping () -> Void,
        timeout: TimeInterval = 0.05,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "wait for completion")
        
        sut.load(payload) {
            XCTAssertNoDiff($0, expectedResult, file: file, line: line)
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: timeout)
    }
}
