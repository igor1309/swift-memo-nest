//
//  EntryLoaderIntegrationTests.swift
//  MemoNestTests
//
//  Created by Igor Malyarov on 19.07.2024.
//

import Cache
import CacheInfra
@testable import MemoNest

struct EntryPayload<Entry: Identifiable>: Filtering, Sorting {
    
    let lastID: Entry.ID?
    
    func predicate(_ entry: Entry) -> Bool {
        
#warning("use Predicate/Filter from module")
        return true
    }
    
    func areInIncreasingOrder(_ lhs: Entry, _ rhs: Entry) -> Bool {
        
#warning("use Sort from module")
        return true
    }
}

extension EntryPayload: Equatable where Entry: Equatable {}

extension InMemoryCache {
    
    func retrieve<Payload>(
        for payload: Payload
    ) throws -> [Item] where Payload: Filtering<Item> & Sorting<Item> {
        
#warning("restore `areInIncreasingOrder` line")
        return try retrieve(
            predicate: payload.predicate(_:),
            areInIncreasingOrder: nil
            // areInIncreasingOrder: payload.areInIncreasingOrder(_:_:)
        )
    }
    //    func retrieve<Payload>(
    //        payload: Payload
    //    ) throws -> [Item] where Payload: Filtering<Item> & Sorting<Item> {
    //
    //#warning("restore `areInIncreasingOrder` line")
    //        return try retrieve(
    //            predicate: payload.predicate(_:),
    //            areInIncreasingOrder: nil
    //            // areInIncreasingOrder: payload.areInIncreasingOrder(_:_:)
    //        )
    //    }
}

import Foundation

final class EntryCacheCoordinatorComposer<Entry: Identifiable> {
    
    private let entryCache: InMemoryCache<Entry>
    private let retrieve: Retrieve
    
    init(
        entryCache: InMemoryCache<Entry>,
        retrieve: @escaping Retrieve
    ) {
        self.entryCache = entryCache
        self.retrieve = retrieve
    }
    
    typealias Retrieve = () throws -> [Entry]
}

extension EntryCacheCoordinatorComposer {
    
    func composeLoad() -> Load {
        
        return composeLoader().load(_:_:)
    }
    
    typealias LoadPayload = EntryPayload<Entry>
    typealias LoadResult = Result<[Entry], Error>
    typealias LoadCompletion = (LoadResult) -> Void
    typealias Load = (LoadPayload, @escaping LoadCompletion) -> Void
}

private extension EntryCacheCoordinatorComposer {
    
    func composeLoader() -> any Loader<LoadPayload, [Entry], Error> {
        
        return FallbackCacheLoader<EntryPayload, [Entry], Error>(
            primaryLoad: { payload, completion in
                
                Task {
                    
                    do {
                        let items = try await self.entryCache.retrieve(for: payload)
                        completion(.success(items))
                    } catch {
                        completion(.failure(error))
                    }
                }
            },
            secondaryLoad: { _, completion in
                
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    completion(.init { try self.retrieve() })
                }
            },
            cache: { _, entries in
                
                Task {
                    
                    await self.entryCache.cache(entries)
                }
            }
        )
    }
}

import MemoNest
import XCTest

final class EntryCacheCoordinatorComposerTests: XCTestCase {
    
    override func setUp() {
        
        super.setUp()
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        
        super.tearDown()
        undoStoreSideEffects()
    }
    
    func test_load_shouldDeliverFailureOnUnloadedStore() {
        
        let load = makeSUT().load
        
        assert(load, toDeliver: .failure(anyError()))
    }
    
    // MARK: - Helpers
    
    private typealias Entry = MemoNest.Entry
    
    private typealias Composer = EntryCacheCoordinatorComposer<Entry>
    private typealias Load = Composer.Load
    
    private typealias EntryCache = InMemoryCache<Entry>
    private typealias PersistentStore = CodableEntryStore
    
    private func makeSUT(
        storeURL: URL? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        load: Load,
        inMemory: EntryCache,
        persistent: PersistentStore
    ) {
        let entryCache = EntryCache()
        let persistent = PersistentStore(storeURL: storeURL ?? testStoreURL())
        
        let composer = Composer(
            entryCache: entryCache,
            retrieve: { try persistent.retrieve().map(Entry.init) }
        )
        
        trackForMemoryLeaks(composer, file: file, line: line)
        trackForMemoryLeaks(entryCache, file: file, line: line)
        trackForMemoryLeaks(persistent, file: file, line: line)
        
        return (composer.composeLoad(), entryCache, persistent)
    }
    
    private func anyPayload(
        lastID: Entry.ID? = nil
    ) -> EntryPayload<Entry> {
        
        return .init(lastID: lastID)
    }
    
    private func setupEmptyStoreState() {
        
        clearArtefacts()
    }
    
    private func undoStoreSideEffects() {
        
        clearArtefacts()
    }
    
    private func clearArtefacts() {
        
        try? FileManager.default.removeItem(at: testStoreURL())
    }
    
    private func testStoreURL() -> URL {
        
        cachesDirectory()
            .appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        
        return FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
    }
    
    private func assert(
        _ load: Load,
        with payload: EntryPayload<Entry>? = nil,
        toDeliver expectedResult: Composer.LoadResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "wait for completion")
        
        load(payload ?? anyPayload()) {
            
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
}

private extension MemoNest.Entry {
    
    init(entry: CacheInfra.Entry) {
        
        self.init(
            id: entry.id,
            creationDate: entry.creationDate,
            modificationDate: entry.modificationDate,
            title: entry.title,
            url: entry.url,
            note: entry.note,
            tags: entry.tags
        )
    }
}
