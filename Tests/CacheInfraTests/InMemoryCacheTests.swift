//
//  InMemoryCacheTests.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

import CacheInfra
import XCTest

final class InMemoryCacheTests: XCTestCase {
    
    func test_init() {
        
        _ = makeSUT()
    }
    
    func test_retrieve_shouldDeliverFailure() async {
        
        await assertThrowsAsyncError(try await retrieve()) {
            
            XCTAssertTrue($0 is SUT.UninitialisedCacheFailure)
        }
    }
    
    func test_retrieve_shouldDeliverEmptyCachedItems() async throws {
        
        let sut = makeSUT()
        
        await sut.cache([])
        let retrieved = try await retrieve(sut)
        
        XCTAssertNoDiff(retrieved, [])
    }
    
    func test_retrieve_shouldDeliverOneCachedItem() async throws {
        
        let item = makeItem()
        let sut = makeSUT()
        
        await sut.cache([item])
        let retrieved = try await retrieve(sut)
        
        XCTAssertNoDiff(retrieved, [item])
    }
    
    func test_retrieve_shouldDeliverCachedItems() async throws {
        
        let items = makeItems(count: 13)
        let sut = makeSUT()
        
        await sut.cache(items)
        let retrieved = try await retrieve(sut)
        
        XCTAssertNoDiff(retrieved, items)
    }
    
    func test_retrieve_shouldDeliverFilteredItems() async throws {
        
        let (a, b) = (makeItem("a"), makeItem("b"))
        let sut = makeSUT()
        
        await sut.cache([a, b])
        let retrieved = try await retrieve(sut, filter: { $0.value.contains("a") })
        
        XCTAssertNoDiff(retrieved, [a])
    }
    
    func test_retrieve_shouldDeliverSortedItems() async throws {
        
        let (a, b) = (makeItem("a"), makeItem("b"))
        let sut = makeSUT()
        
        await sut.cache([a, b])
        let retrieved = try await retrieve(sut, areInIncreasingOrder: { $0.value > $1.value })
        
        XCTAssertNoDiff(retrieved, [b, a])
    }
    
    func test_retrieve_shouldDeliverNewCachedItems() async throws {
        
        let items = makeItems(count: 7)
        let sut = makeSUT()
        
        await sut.cache(makeItems(count: 13))
        await sut.cache(items)
        let retrieved = try await retrieve(sut)
        
        XCTAssertNoDiff(retrieved, items)
    }
    
    func test_retrieveByID_shouldThrow() async throws {
        
        let sut = makeSUT()
        
        await assertThrowsAsyncError(try await sut.retrieve(byID: makeItem().id)) {
            
            XCTAssertTrue($0 is SUT.UninitialisedCacheFailure)
        }
    }
    
    func test_retrieveByID_shouldDeliverCachedItem() async throws {
        
        let items = makeItems(count: 7)
        let sut = makeSUT()
        
        await sut.cache(items)
        let item = try await sut.retrieve(byID: items[3].id)
        
        XCTAssertNoDiff(item, items[3])
    }
    
    func test_retrieveByID_shouldReturnNilForMissingItem() async throws {
        
        let items = makeItems(count: 7)
        let sut = makeSUT()
        
        await sut.cache(items)
        let item = try await sut.retrieve(byID: UUID())
        
        XCTAssertNil(item)
    }
    
    func test_cache_shouldAddNewItem() async throws {
        
        let items = makeItems(count: 7)
        let item = makeItem()
        let sut = makeSUT()
        
        await sut.cache(items)
        await sut.cache(item)
        let retrieved = try await retrieve(sut)
        
        XCTAssertNoDiff(retrieved, items + [item])
    }
    
    func test_cache_shouldUpdateFirstExistingItem() async throws {
        
        var items = makeItems(count: 7)
        let item = makeItem(id: items[0].id)
        let sut = makeSUT()
        
        await sut.cache(items)
        await sut.cache(item)
        let retrieved = try await retrieve(sut)
        
        items[0] = item
        XCTAssertNoDiff(retrieved[0], item)
        XCTAssertNoDiff(retrieved, items)
    }
    
    func test_cache_shouldUpdateExistingItem() async throws {
        
        var items = makeItems(count: 7)
        let item = makeItem(id: items[1].id)
        let sut = makeSUT()
        
        await sut.cache(items)
        await sut.cache(item)
        let retrieved = try await retrieve(sut)
        
        items[1] = item
        XCTAssertNoDiff(retrieved[1], item)
        XCTAssertNoDiff(retrieved, items)
    }
    
    func test_cache_shouldUpdateLastExistingItem() async throws {
        
        var items = makeItems(count: 7)
        let item = makeItem(id: items[6].id)
        let sut = makeSUT()
        
        await sut.cache(items)
        await sut.cache(item)
        let retrieved = try await retrieve(sut)
        
        items[6] = item
        XCTAssertNoDiff(retrieved[6], item)
        XCTAssertNoDiff(retrieved, items)
    }
    
    func test_remove_shouldThrow() async throws {
        
        let sut = makeSUT()
        
        await assertThrowsAsyncError(try await sut.remove(byID: makeItem().id)) {
            
            XCTAssertTrue($0 is SUT.UninitialisedCacheFailure)
        }
    }
    
    func test_remove_shouldRemoveItemByID() async throws {
        
        var items = makeItems(count: 7)
        let sut = makeSUT()
        
        await sut.cache(items)
        try await sut.remove(byID: items[3].id)
        let retrieved = try await retrieve(sut)
        
        items.remove(at: 3)
        XCTAssertNoDiff(retrieved, items)
    }
    
    func test_clear_shouldEmptyCache() async throws {
        
        let items = makeItems(count: 7)
        let sut = makeSUT()
        
        await sut.cache(items)
        await sut.clear()
        
        await assertThrowsAsyncError(try await retrieve(sut)) {
            
            XCTAssertTrue($0 is SUT.UninitialisedCacheFailure)
        }
    }
    
    // MARK: - Helpers
    
    private typealias SUT = InMemoryCache<Item>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT {
        
        let sut = SUT()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private struct Item: Equatable, Identifiable {
        
        let id: UUID
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
        id: UUID = .init(),
        _ value: String = UUID().uuidString
    ) -> Item {
        
        return .init(id: id, value: value)
    }
    
    // MARK: - DSL
    
    private func retrieve(
        _ sut: SUT? = nil,
        filter predicate: ((Item) -> Bool)? = { _ in true },
        areInIncreasingOrder: ((Item, Item) -> Bool)? = nil
    ) async throws -> [Item] {
        
        let sut = sut ?? makeSUT()
        
        return try await sut.retrieve(
            predicate: predicate,
            areInIncreasingOrder: areInIncreasingOrder
        )
    }
}
