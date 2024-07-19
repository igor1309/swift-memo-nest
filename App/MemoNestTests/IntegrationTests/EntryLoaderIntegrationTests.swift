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

extension InMemoryStore {
    
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

final class EntryLoaderComposer {
    
    private let storeURL: URL
    
    init(storeURL: URL) {
        
        self.storeURL = storeURL
    }
}

extension EntryLoaderComposer {
    
    func compose() -> any Loader {
        
        let inMemoryStore = InMemoryStore<Entry>()
        let persistentStore = CodableEntryStore(storeURL: storeURL)
        
        let loader = FallbackCacheLoader<Payload, [Entry], Error>(
            primaryLoad: { payload, completion in
                
                Task {
                    
                    do {
                        let items = try await inMemoryStore.retrieve(payload: payload)
                        completion(.success(items))
                    } catch {
                        completion(.failure(error))
                    }
                }
            },
            secondaryLoad: { _, completion in
            
                DispatchQueue.global(qos: .userInitiated).async {
                 
                    completion(.init { try persistentStore.retrieve() })
                }
            },
            cache: { _, entries in
                
                DispatchQueue.global(qos: .background).async {
                    
                    try? persistentStore.insert(entries)
                }
            }
        )
        
        return loader
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
    
    // MARK: - Helpers
    
    private typealias Composer = EntryLoaderComposer
    private typealias SUT = any Loader
    
    private func makeSUT(
        storeURL: URL? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT {
        
        let composer = Composer(storeURL: storeURL ?? testStoreURL())
        
        trackForMemoryLeaks(composer, file: file, line: line)
        
        return composer.compose()
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
}
