//
//  CodableStoreTests.swift
//
//
//  Created by Igor Malyarov on 19.07.2024.
//

import CacheInfra
import XCTest

final class CodableStoreTests: XCTestCase {
    
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
    
    func test_retrieve_shouldThrowOnEmptyCache() async throws {
        
        let sut = makeSUT()
        
        try await assertThrowsAsyncError(await sut.retrieve())
    }
    
    func test_retrieve_shouldHaveNoSideEffectsOnEmptyCache() async throws {
        
        let sut = makeSUT()
        
        try await assertThrowsAsyncError(await sut.retrieve())
        try await assertThrowsAsyncError(await sut.retrieve())
    }
    
    func test_retrieve_shouldDeliverInsertedValues() async throws {
        
        let entry = makeEntry()
        let sut = makeSUT()
        try await sut.insert(entry)
        
        let retrieved = try await sut.retrieve()
        
        XCTAssertNoDiff(retrieved, entry)
    }
    
    func test_retrieve_shouldHaveNoSideEffectsOnNonEmptyCache() async throws {
        
        let entry = makeEntry()
        let sut = makeSUT()
        try await sut.insert(entry)
        
        let retrievedFirst = try await sut.retrieve()
        let retrievedSecond = try await sut.retrieve()
        
        XCTAssertNoDiff(retrievedFirst, entry)
        XCTAssertNoDiff(retrievedFirst, retrievedSecond)
    }
    
    func test_retrieve_shouldDeliverErrorOnRetrievalFailure() async throws {
        
        let storeURL = testStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try "invalid data".write(to: storeURL, atomically: true, encoding: .utf8)
        
        try await assertThrowsAsyncError(await sut.retrieve())
    }
    
    func test_retrieve_shouldHaveNoSideEffectsOnRetrievalFailure() async throws {
        
        let storeURL = testStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        try "invalid data".write(to: storeURL, atomically: true, encoding: .utf8)
        
        try await assertThrowsAsyncError(await sut.retrieve())
        try await assertThrowsAsyncError(await sut.retrieve())
    }
    
    func test_insert_shouldDeliverNoErrorOnEmptyCache() async throws {
        
        let sut = makeSUT()
        
        try await sut.insert(self.makeEntry())
    }
    
    func test_insert_shouldDeliverNoErrorOnNonEmptyCache() async throws {
        
        let sut = makeSUT()
        
        try await sut.insert(makeEntry())
        try await sut.insert(makeEntry())
    }
    
    func test_insert_shouldOverridePreviouslyInsertedCache() async throws {
        
        let entry = makeEntry()
        let sut = makeSUT()
        
        try await sut.insert(makeEntry())
        try await sut.insert(entry)
        
        let retrieved = try await sut.retrieve()
        XCTAssertNoDiff(retrieved, entry)
    }
    
    func test_insert_shouldDeliverErrorOnInsertionFailure() async throws {
        
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        
        await assertThrowsAsyncError(try await sut.insert(makeEntry()))
    }
    
    func test_insert_shouldHaveNoSideEffectsOnInsertionFailure() async throws {
        
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        
        await assertThrowsAsyncError(try await sut.insert(makeEntry()))
        await assertThrowsAsyncError(try await sut.retrieve())
    }
    
    func test_delete_shouldThrowOnEmptyCache() async throws {
        
        let sut = makeSUT()
        
        await assertThrowsAsyncError(try await sut.delete())
    }
    
    func test_delete_shouldHaveNoSideEffectsOnEmptyCache() async throws {
        
        let sut = makeSUT()
        
        try? await sut.delete()
        
        await assertThrowsAsyncError(try await sut.retrieve())
    }
    
    func test_delete_shouldDeliverNoErrorOnNonEmptyCache() async throws {
        
        let sut = makeSUT()
        try await sut.insert(makeEntry())
        
        try await sut.delete()
    }
    
    func test_delete_shouldEmptyPreviouslyInsertedCache() async throws {
        
        let sut = makeSUT()
        try await sut.insert(makeEntry())
        
        try await sut.delete()
        
        await assertThrowsAsyncError(try await sut.retrieve())
    }
    
    func test_delete_shouldDeliverErrorOnDeletionFailure() async throws {
        
        let sut = makeSUT(storeURL: noDeletePermissionURL())
        
        await assertThrowsAsyncError(try await sut.delete())
    }
    
    func test_delete_shouldHaveNoSideEffectsOnDeletionFailure() async throws {
        
        let sut = makeSUT(storeURL: noDeletePermissionURL())
        
        await assertThrowsAsyncError(try await sut.delete())
        await assertThrowsAsyncError(try await sut.retrieve())
    }
    
    // MARK: - Helpers
    
    private typealias SUT = CodableStore<Entry>
    private typealias RetrievalResult = Result<Entry, Error>
    
    private func makeSUT(
        storeURL: URL? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT {
        
        let sut = SUT(storeURL: storeURL ?? testStoreURL())
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
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
    
    private func noDeletePermissionURL() -> URL {
        
        return FileManager.default
            .urls(for: .cachesDirectory, in: .systemDomainMask)
            .first!
    }
    
    private func makeEntry(
        id: UUID = .init(),
        creationDate: Date = .init(),
        modificationDate: Date = .init(),
        title: String = UUID().uuidString,
        url: URL? = nil,
        note: String = UUID().uuidString,
        tags: [String] = []
    ) -> Entry {
        
        return .init(id: id, creationDate: creationDate, modificationDate: modificationDate, title: title, url: url, note: note, tags: tags)
    }
    
    private struct Entry: Equatable, Codable {
        
        let id: UUID
        let creationDate: Date
        let modificationDate: Date
        let title: String
        let url: URL?
        let note: String
        let tags: [String]
    }
}
