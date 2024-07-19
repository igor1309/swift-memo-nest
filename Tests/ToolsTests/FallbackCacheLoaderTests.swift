//
//  FallbackCacheLoaderTests.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Tools
import XCTest

final class FallbackCacheLoaderTests: XCTestCase {
    
    func test_init_shouldNotCallCollaborators() {
        
        let (_, primaryLoader, secondaryLoader, updateSpy) = makeSUT()
        
        XCTAssertEqual(primaryLoader.callCount, 0)
        XCTAssertEqual(secondaryLoader.callCount, 0)
        XCTAssertEqual(updateSpy.callCount, 0)
    }
    
    func test_load_deliversSuccessFromInMemoryLoader() {
        
        let payload = "testPayload"
        let primarySuccess = "primarySuccess"
        let (sut, primaryLoader, _, _) = makeSUT()
        
        assert(sut, with: payload, toDeliver: .success(primarySuccess)) {
            
            primaryLoader.complete(with: .success(primarySuccess))
        }
    }
    
    func test_load_fallsBackToPersistentLoaderOnInMemoryFailure() {
        
        let payload = "testPayload"
        let (sut, primaryLoader, secondaryLoader, _) = makeSUT()
        
        sut.load(payload) { _ in }
        primaryLoader.complete(with: .failure(self.anyError()))
        
        XCTAssertNoDiff(secondaryLoader.payloads, [payload])
    }
    
    func test_load_updatesInMemoryStoreOnPersistentSuccess() {
        
        let payload = "testPayload"
        let secondarySuccess = "secondarySuccess"
        let (sut, primaryLoader, secondaryLoader, updateSpy) = makeSUT()
        
        assert(sut, with: payload, toDeliver: .success(secondarySuccess)) {
            
            primaryLoader.complete(with: .failure(self.anyError()))
            secondaryLoader.complete(with: .success(secondarySuccess))
        }
        
        XCTAssertNoDiff(updateSpy.payloads.map(\.0), ["testPayload"])
        XCTAssertNoDiff(updateSpy.payloads.map(\.1), ["secondarySuccess"])
    }
    
    func test_load_deliversFailureWhenBothLoadersFail() {
        
        let payload = "testPayload"
        let failure = anyFailure()
        let (sut, primaryLoader, secondaryLoader, _) = makeSUT()
        
        assert(sut, with: payload, toDeliver: .failure(failure)) {
            
            primaryLoader.complete(with: .failure(self.anyError()))
            secondaryLoader.complete(with: .failure(failure))
        }
    }
    
    // MARK: - Helpers
    
    private typealias SUT = FallbackCacheLoader<String, String, Failure>
    private typealias PrimarySpy = Spy<String, String, Error>
    private typealias SecondarySpy = Spy<String, String, Failure>
    private typealias CacheSpy = CallSpy<(String, String), Void>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: SUT,
        primary: PrimarySpy,
        secondary: SecondarySpy,
        updateSpy: CacheSpy
    ) {
        let primary = PrimarySpy()
        let secondary = SecondarySpy()
        let updateSpy = CacheSpy(stubs: [()])
        let sut = SUT(
            primaryLoader: primary,
            secondaryLoader: secondary,
            cache: updateSpy.call
        )
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(primary, file: file, line: line)
        trackForMemoryLeaks(secondary, file: file, line: line)
        
        return (sut, primary, secondary, updateSpy)
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
    
    private func anyError() -> NSError {
        
        return NSError(domain: "test", code: 0, userInfo: nil)
    }
    
    private struct Failure: Error, Equatable {
        
        let value: String
    }
    
    private func anyFailure(
        _ value: String = UUID().uuidString
    ) -> Failure {
        
        return .init(value: value)
    }
}
