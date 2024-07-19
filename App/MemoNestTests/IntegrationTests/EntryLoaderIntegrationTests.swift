//
//  EntryLoaderIntegrationTests.swift
//  MemoNestTests
//
//  Created by Igor Malyarov on 19.07.2024.
//

import CacheInfra
import Tools

extension Entry: Identifiable {}

extension FallbackCacheLoader {
    
    convenience init(
        primaryLoad: @escaping (Payload, @escaping (Result<Success, Error>) -> Void) -> Void,
        secondaryLoad: @escaping (Payload, @escaping (LoadResult) -> Void) -> Void,
        cache: @escaping (Payload, Success) -> Void
    ) {
        self.init(
            primaryLoader: AnyLoader(load: primaryLoad),
            secondaryLoader: AnyLoader(load: secondaryLoad),
            cache: cache
        )
    }
}

struct Payload: Equatable, Filtering, Sorting{
    
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

protocol Filtering<Item> {
    
    associatedtype Item
    
    func predicate(_: Item) -> Bool
}

protocol Sorting<Item> {
    
    associatedtype Item
    
    func areInIncreasingOrder(_: Item, _: Item) -> Bool
}

extension InMemoryCache {
    
    func retrieve<Payload>(
        payload: Payload
    ) throws -> [Item] where Payload: Filtering<Item> & Sorting<Item> {
        
#warning("restore `areInIncreasingOrder` line")
        return try retrieve(
            predicate: payload.predicate(_:),
            areInIncreasingOrder: nil
            // areInIncreasingOrder: payload.areInIncreasingOrder(_:_:)
        )
    }
}

protocol Store<Item> {
    
    associatedtype Item
    
    func retrieve() throws -> [Item]
    func insert(_: [Item]) throws
    func delete() throws
}

extension CodableEntryStore: Store {}

import Foundation

final class EntryLoaderComposer {
    
    private let entryCache: InMemoryCache<Entry>
    private let persistent: any Store<Entry>
    
    init(
        entryCache: InMemoryCache<Entry>,
        persistent: any Store<Entry>
    ) {
        self.entryCache = entryCache
        self.persistent = persistent
    }
}

extension EntryLoaderComposer {
    
    typealias LoadResult = Result<[Entry], Error>
    typealias LoadCompletion = (LoadResult) -> Void
    typealias Load = (Payload, @escaping LoadCompletion) -> Void
    
    func composeLoad() -> Load {
        
        let loader = FallbackCacheLoader<Payload, [Entry], Error>(
            primaryLoad: { payload, completion in
                
                Task {
                    
                    do {
                        let items = try await self.entryCache.retrieve(payload: payload)
                        completion(.success(items))
                    } catch {
                        completion(.failure(error))
                    }
                }
            },
            secondaryLoad: { _, completion in
                
                DispatchQueue.global(qos: .userInitiated).async {
                    
                    completion(.init { try self.persistent.retrieve() })
                }
            },
            cache: { _, entries in
                
                Task {
                    
                    await self.entryCache.cache(entries)
                }
            }
        )
        
        return loader.load(_:_:)
    }
}

import MemoNest
import XCTest

final class EntryLoaderComposerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        undoStoreSideEffects()
    }
    
    func test_init() {
        
        _ = makeSUT()
    }
    
    func test_load_shouldDeliverFailureOnUnloadedStore() {
        
        assert(with: anyPayload(), toDeliver: .failure(anyError()))
    }
    
    // MARK: - Helpers
    
    private typealias Composer = EntryLoaderComposer
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
            persistent: persistent
        )
        
        trackForMemoryLeaks(composer, file: file, line: line)
        trackForMemoryLeaks(entryCache, file: file, line: line)
        trackForMemoryLeaks(persistent, file: file, line: line)
        
        return (composer.composeLoad(), entryCache, persistent)
    }
    
    private func anyPayload(
        lastID: Entry.ID? = nil
    ) -> Payload {
        
        return .init(lastID: lastID)
    }
    
    private func setupEmptyStoreState() {
        
        clearArtifacts()
    }
    
    private func undoStoreSideEffects() {
        
        clearArtifacts()
    }
    
    private func clearArtifacts() {
        
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
        load: Load? = nil,
        with payload: Payload,
        toDeliver expectedResult: Composer.LoadResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let load = load ?? makeSUT(file: file, line: line).load
        
        let exp = expectation(description: "wait for completion")
        
        load(.init(lastID: nil)) {
            
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
