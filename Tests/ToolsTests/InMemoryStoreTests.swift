//
//  InMemoryStoreTests.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

actor InMemoryStore<Item> {
    
    private var items: [Item]?
}

extension InMemoryStore {
    
    func retrieve() throws -> [Item] {
        
        guard let items
        else { throw PreloadFailure() }
        
        return items
    }
    
    struct PreloadFailure: Error, Equatable {}
}

extension InMemoryStore {
    
    func cache(_ items: [Item]) throws {
        
        self.items = items
    }
}

import XCTest

final class InMemoryStoreTests: XCTestCase {
    
    func test_init() {
        
        _ = makeSUT()
    }
    
    func test_retrieve_shouldDeliverFailure() async {
        
        await assertThrowsAsyncError(try await retrieve()) {
            
            XCTAssertNoDiff(
                $0 as! InMemoryStoreTests.SUT.PreloadFailure,
                SUT.PreloadFailure()
            )
        }
    }
    
    func test_retrieve_shouldDeliverEmptyCachedItems() async throws {
        
        let sut = makeSUT()
        
        try await sut.cache([])
        let retrieved = try await retrieve(sut)
        
        XCTAssertNoDiff(retrieved, [])
    }
    
    func test_retrieve_shouldDeliverOneCachedItem() async throws {
        
        let item = makeItem()
        let sut = makeSUT()
        
        try await sut.cache([item])
        let retrieved = try await retrieve(sut)
        
        XCTAssertNoDiff(retrieved, [item])
    }
    
    func test_retrieve_shouldDeliverCachedItems() async throws {
        
        let items = makeItems(count: 13)
        let sut = makeSUT()
        
        try await sut.cache(items)
        let retrieved = try await retrieve(sut)
        
        XCTAssertNoDiff(retrieved, items)
    }
    
    func test_retrieve_shouldDeliverNewCachedItems() async throws {
        
        let items = makeItems(count: 7)
        let sut = makeSUT()
        
        try await sut.cache(makeItems(count: 13))
        try await sut.cache(items)
        let retrieved = try await retrieve(sut)
        
        XCTAssertNoDiff(retrieved, items)
    }
    
    // MARK: - Helpers
    
    private typealias SUT = InMemoryStore<Item>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT {
        
        let sut = SUT()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private struct Item: Equatable {
        
        let value: String
    }
    
    private func makeItems(
        count: Int = .random(in: 1...100)
    ) -> [Item] {
        
        let items = (0..<count).map { _ in
            
            makeItem()
        }
        precondition(items.count == count)
        
        return items
    }
    
    private func makeItem(
        _ value: String = UUID().uuidString
    ) -> Item {
        
        return .init(value: value)
    }
    
    // MARK: - DSL
    
    private func retrieve(
        _ sut: SUT? = nil
    ) async throws -> [Item] {
        
        let sut = sut ?? makeSUT()
        
        return try await sut.retrieve()
    }
}
