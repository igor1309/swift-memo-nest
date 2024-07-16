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
        
        let (_, inMemoryLoader, persistentLoader, updateSpy) = makeSUT()
        
        XCTAssertEqual(inMemoryLoader.callCount, 0)
        XCTAssertEqual(persistentLoader.callCount, 0)
        XCTAssertEqual(updateSpy.callCount, 0)
    }
    
    func test_load_deliversSuccessFromInMemoryLoader() {
        
        let payload = "testPayload"
        let inMemorySuccess = "inMemorySuccess"
        let (sut, inMemoryLoader, _, _) = makeSUT()
        
        assert(sut, with: payload, toDeliver: .success(inMemorySuccess)) {
            
            inMemoryLoader.complete(with: .success(inMemorySuccess))
        }
    }
    
    func test_load_fallsBackToPersistentLoaderOnInMemoryFailure() {
        
        let payload = "testPayload"
        let (sut, inMemoryLoader, persistentLoader, _) = makeSUT()
        
        sut.load(payload) { _ in }
        inMemoryLoader.complete(with: .failure(self.anyError()))
        
        XCTAssertNoDiff(persistentLoader.payloads, [payload])
    }
    
    func test_load_updatesInMemoryStoreOnPersistentSuccess() {
        
        let payload = "testPayload"
        let persistentSuccess = "persistentSuccess"
        let (sut, inMemoryLoader, persistentLoader, updateSpy) = makeSUT()
        
        assert(sut, with: payload, toDeliver: .success(persistentSuccess)) {
            
            inMemoryLoader.complete(with: .failure(self.anyError()))
            persistentLoader.complete(with: .success(persistentSuccess))
        }
        
        XCTAssertNoDiff(updateSpy.payloads.map(\.0), ["testPayload"])
        XCTAssertNoDiff(updateSpy.payloads.map(\.1), ["persistentSuccess"])
    }
    
    func test_load_deliversFailureWhenBothLoadersFail() {
        
        let payload = "testPayload"
        let failure = anyFailure()
        let (sut, inMemoryLoader, persistentLoader, _) = makeSUT()
        
        assert(sut, with: payload, toDeliver: .failure(failure)) {
            
            inMemoryLoader.complete(with: .failure(self.anyError()))
            persistentLoader.complete(with: .failure(failure))
        }
    }
    
    // MARK: - Helpers
    
    private typealias SUT = FallbackCacheLoader<String, String, Failure>
    private typealias InMemorySpy = Spy<String, String, Error>
    private typealias PersistentSpy = Spy<String, String, Failure>
    private typealias UpdateSpy = CallSpy<(String, String), Void>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: SUT,
        inMemory: InMemorySpy,
        persistent: PersistentSpy,
        updateSpy: UpdateSpy
    ) {
        let inMemory = InMemorySpy()
        let persistent = PersistentSpy()
        let updateSpy = UpdateSpy(stubs: [()])
        let sut = SUT(
            inMemoryLoader: inMemory,
            persistentLoader: persistent,
            updateInMemoryStore: updateSpy.call
        )
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(inMemory, file: file, line: line)
        trackForMemoryLeaks(persistent, file: file, line: line)
        
        return (sut, inMemory, persistent, updateSpy)
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
