//
//  ReadCacheCoordinatorTests.swift
//
//
//  Created by Igor Malyarov on 20.07.2024.
//

import Cache
import CacheInfra
import XCTest

final class ReadCacheCoordinatorTests: XCTestCase {
    
    func test_init_shouldNotCallCollaborators() {
        
        let (sut, entryCache, retrieveSpy) = makeSUT()
        
        XCTAssertNotNil(entryCache)
        // XCTAssertEqual(entryCache.callCount, 0)
        XCTAssertEqual(retrieveSpy.callCount, 0)
        XCTAssertNotNil(sut)
    }
    
    func test_load_shouldCallRetrieve() {
        
        let (sut, _, retrieveSpy) = makeSUT(stubs: .failure(anyError()))
        
        load(sut)
        
        XCTAssertEqual(retrieveSpy.callCount, 1)
    }
    
    func test_load_shouldDeliverFailureOnRetrieveFailure() {
        
        let (sut, _,_) = makeSUT(stubs: .failure(anyError()))
        
        expect(sut: sut, toDeliver: .failure(anyError()))
    }
    
    func test_load_shouldDeliverEmptyEntriesOnEmptyRetrieveSuccess() {
        
        let (sut, _,_) = makeSUT(stubs: .success([]))
        
        expect(sut: sut, toDeliver: .success([]))
    }
    
    func test_load_shouldDeliverEntriesOnRetrieveSuccess() {
        
        let entries = makeEntries(count: 13)
        let (sut, _,_) = makeSUT(stubs: .success(entries))
        
        expect(sut: sut, toDeliver: .success(entries))
    }
    
    func test_load_shouldCallRetrieveOnce() {
        
        let (sut, _, retrieveSpy) = makeSUT(
            stubs: .success(makeEntries()), .success(makeEntries()), .success(makeEntries())
        )
        
        load(sut)
        load(sut)
        load(sut)
        
        XCTAssertEqual(retrieveSpy.callCount, 1)
    }
    
    // MARK: - Helpers
    
    private typealias SUT = ReadCacheCoordinator<Payload, Entry>
    private typealias EntryCache = InMemoryCache<Entry>
    private typealias RetrieveSpy = CallSpy<Void, Result<[Entry], Error>>
    
    private func makeSUT(
        stubs: Result<[Entry], Error>...,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: SUT,
        entryCache: EntryCache,
        retrieveSpy: RetrieveSpy
    ) {
        let entryCache = EntryCache()
        let retrieveSpy = RetrieveSpy(stubs: stubs)
        let sut = SUT(
            entryCache: entryCache,
            retrieve: retrieveSpy.call
        )
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(entryCache, file: file, line: line)
        trackForMemoryLeaks(retrieveSpy, file: file, line: line)
        
        return (sut, entryCache, retrieveSpy)
    }
    
    private func anyPayload(
        value: String = anyMessage()
    ) -> Payload {
        
        return .init(value: value)
    }
    
    private func makeEntry(
        id: UUID = .init(),
        value: String = anyMessage()
    ) -> Entry {
        
        return .init(id: id, value: value)
    }
    
    private func makeEntries(
        count: Int = .random(in: 0..<13)
    ) -> [Entry] {
        
        let entries = (0..<count).map { _ in makeEntry() }
        precondition(entries.count == count)
        
        return entries
    }
    
    private struct Payload: Filtering & Sorting {
        
        let value: String
        
        func predicate(_ entry: Entry) -> Bool {
            
            return true
        }
        
        func areInIncreasingOrder(
            _ lhs: Entry,
            _ rhs: Entry
        ) -> Bool {
            
            return true
        }
    }
    
    private struct Entry: Equatable, Identifiable {
        
        let id: UUID
        let value: String
    }
    
    private func expect(
        sut: SUT? = nil,
        with payload: Payload? = nil,
        toDeliver expectedResult: Result<[Entry], Error>,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let sut = sut ?? makeSUT().sut
        let exp = expectation(description: "wait for completion")
        
        sut.load(payload ?? anyPayload()) {
            
            switch ($0, expectedResult) {
            case (.failure, .failure):
                break
                
            case let (.success(receivedEntries), .success(expectedEntries)):
                XCTAssertNoDiff(receivedEntries, expectedEntries, file: file, line: line)
                
            default:
                XCTFail("Expected \(expectedResult), but got \($0) instead.", file: file, line: line)
            }
            
            exp.fulfill()
        }
        
        wait(for: [exp], timeout: 0.1)
    }
    
    // MARK: - DSL
    
    private func load(
        _ sut: SUT,
        with payload: Payload? = nil
    ) {
        let exp = expectation(description: "wait for completion")
        sut.load(payload ?? anyPayload()) { _ in exp.fulfill() }
        wait(for: [exp], timeout: 0.1)
    }
}
