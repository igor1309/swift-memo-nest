//
//  InMemoryStoreTests.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

actor InMemoryStore<Item>
where Item: Identifiable {
    
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
    
    func cache(_ item: Item) throws {
        
        guard var items
        else { throw PreloadFailure() }
        
        if let index = items.firstIndex(matchingID: item.id) {
            items[index] = item
        } else {
            items.append(item)
        }
        
        self.items = items
    }
    
    func cache(_ items: [Item]) {
        
        self.items = items
    }
}

extension InMemoryStore {
    
    func remove(byID id: Item.ID) throws {
        
        guard var items
        else { throw PreloadFailure() }
        
        items.removeAll { $0.id == id }
        self.items = items
    }
    
    func clear() {
        
        self.items = nil
    }
}

extension Array where Element: Identifiable {
    
    func firstIndex(matchingID id: Element.ID) -> Index? {
        
        return firstIndex(where: { $0.id == id })
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
    
    func test_retrieve_shouldDeliverNewCachedItems() async throws {
        
        let items = makeItems(count: 7)
        let sut = makeSUT()
        
        await sut.cache(makeItems(count: 13))
        await sut.cache(items)
        let retrieved = try await retrieve(sut)
        
        XCTAssertNoDiff(retrieved, items)
    }
    
    func test_cache_shouldAddNewItem() async throws {
        
        let items = makeItems(count: 7)
        let item = makeItem()
        let sut = makeSUT()
        
        await sut.cache(items)
        try await sut.cache(item)
        let retrieved = try await retrieve(sut)
        
        XCTAssertNoDiff(retrieved, items + [item])
    }
    
    func test_cache_shouldUpdateFirstExistingItem() async throws {
        
        var items = makeItems(count: 7)
        let item = makeItem(id: items[0].id)
        let sut = makeSUT()
        
        await sut.cache(items)
        try await sut.cache(item)
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
        try await sut.cache(item)
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
        try await sut.cache(item)
        let retrieved = try await retrieve(sut)
        
        items[6] = item
        XCTAssertNoDiff(retrieved[6], item)
        XCTAssertNoDiff(retrieved, items)
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
            XCTAssertNoDiff(
                $0 as! InMemoryStoreTests.SUT.PreloadFailure,
                SUT.PreloadFailure()
            )
        }
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
        _ sut: SUT? = nil
    ) async throws -> [Item] {
        
        let sut = sut ?? makeSUT()
        
        return try await sut.retrieve()
    }
}
