//
//  CodableEntryStoreTests.swift
//
//
//  Created by Igor Malyarov on 19.07.2024.
//

struct Entry: Equatable {
    
    let id: UUID
    let creationDate: Date
    let modificationDate: Date
    let title: String
    let url: URL?
    let note: String
    let tags: [String]
}

final class CodableEntryStore {
    
    private let storeURL: URL
    
    init(storeURL: URL) {
        self.storeURL = storeURL
    }
}

extension CodableEntryStore {
    
    func retrieve() throws -> [Entry] {
        
        do {
            let data = try Data(contentsOf: storeURL)
            let decoder = JSONDecoder()
            let cache = try decoder.decode([Cache].self, from: data)
            
            return cache.map(\.entry)
        } catch {
            throw RetrievalFailure()
        }
    }
    
    struct RetrievalFailure: Error, Equatable {}
}

extension CodableEntryStore {
    
    func insert(_ entries: [Entry]) throws {
        
        let cache = entries.map { Cache(entry: $0) }
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(cache)
        try encoded.write(to: storeURL)
    }
}

extension CodableEntryStore {
    
    func deleteCachedFeed() throws {
        
        try FileManager.default.removeItem(at: storeURL)
    }
}

private extension CodableEntryStore {
    
    struct Cache: Codable {
        
        let id: UUID
        let creationDate: Date
        let modificationDate: Date
        let title: String
        let url: URL?
        let note: String
        let tags: [String]
        
        init(entry: Entry) {
            
            self.id = entry.id
            self.creationDate = entry.creationDate
            self.modificationDate = entry.modificationDate
            self.title = entry.title
            self.url = entry.url
            self.note = entry.note
            self.tags = entry.tags
        }
        
        var entry: Entry {
            
            return .init(id: id, creationDate: creationDate, modificationDate: modificationDate, title: title, url: url, note: note, tags: tags)
        }
    }
}

import XCTest

final class CodableEntryStoreTests: XCTestCase {
    
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
    
    func test_retrieve_shouldThrowOnEmptyCache() {
        
        let sut = makeSUT()
        
        XCTAssertThrowsError(try sut.retrieve())
    }
    
    func test_retrieve_shouldHaveNoSideEffectsOnEmptyCache() {
        
        let sut = makeSUT()
        
        XCTAssertThrowsError(try sut.retrieve())
        XCTAssertThrowsError(try sut.retrieve())
    }
    
    func test_retrieve_shouldDeliverInsertedValues() throws {
        
        let entries = makeEntries(count: 13)
        let sut = makeSUT()
        
        try sut.insert(entries)
        
        expect(sut, toRetrieve: .success(entries))
    }
    
    func test_retrieve_shouldHaveNoSideEffectsOnNonEmptyCache() throws {
        
        let entries = makeEntries(count: 13)
        let sut = makeSUT()
        
        try sut.insert(entries)
        
        expect(sut, toRetrieve: .success(entries))
        expect(sut, toRetrieve: .success(entries))
    }
    
    func test_retrieve_shouldDeliverErrorOnRetrievalFailure() {
        
        let storeURL = testStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        XCTAssertNoThrow {
            try "invalid data".write(to: storeURL, atomically: true, encoding: .utf8)
            
            XCTAssertThrowsError(_ = try sut.retrieve())
        }
    }
    
    func test_retrieve_shouldHaveNoSideEffectsOnRetrievalFailure() {
        
        let storeURL = testStoreURL()
        let sut = makeSUT(storeURL: storeURL)
        
        XCTAssertNoThrow {
            try "invalid data".write(to: storeURL, atomically: true, encoding: .utf8)
            
            XCTAssertThrowsError(_ = try sut.retrieve())
            XCTAssertThrowsError(_ = try sut.retrieve())
        }
    }
    
    func test_insert_shouldDeliverNoErrorOnEmptyCache() throws {
        
        let sut = makeSUT()
        
        XCTAssertNoThrow(try sut.insert(makeEntries()))
    }
    
    func test_insert_shouldDeliverNoErrorOnNonEmptyCache() throws {
        
        let sut = makeSUT()
        
        XCTAssertNoThrow(try sut.insert(makeEntries()))
        XCTAssertNoThrow(try sut.insert(makeEntries()))
    }
    
    func test_insert_shouldOverridePreviouslyInsertedCache() throws {
        
        let entries = makeEntries(count: 13)
        let sut = makeSUT()
        
        try sut.insert(makeEntries())
        try sut.insert(entries)
        
        expect(sut, toRetrieve: .success(entries))
    }
    
    func test_insert_shouldDeliverErrorOnInsertionFailure() {
        
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        
        XCTAssertThrowsError(try sut.insert(makeEntries()))
    }
    
    func test_insert_shouldHaveNoSideEffectsOnInsertionFailure() {
        
        let invalidStoreURL = URL(string: "invalid://store-url")!
        let sut = makeSUT(storeURL: invalidStoreURL)
        
        XCTAssertThrowsError(try sut.insert(makeEntries()))
        XCTAssertThrowsError(try sut.retrieve())
    }
    
    func test_delete_shouldThrowOnEmptyCache() throws {
        
        let sut = makeSUT()
        
        XCTAssertThrowsError(try sut.deleteCachedFeed())
    }
    
    func test_delete_shouldHaveNoSideEffectsOnEmptyCache() throws {
        
        let sut = makeSUT()
        
        try? sut.deleteCachedFeed()
        XCTAssertThrowsError(try sut.retrieve())
    }
    
    func test_delete_shouldDeliverNoErrorOnNonEmptyCache() throws {
        
        let entries = makeEntries(count: 13)
        let sut = makeSUT()
        try sut.insert(entries)
        expect(sut, toRetrieve: .success(entries))
        
        XCTAssertNoThrow(try sut.deleteCachedFeed())
    }
    
    func test_delete_shouldEmptyPreviouslyInsertedCache() throws {
        
        let entries = makeEntries(count: 13)
        let sut = makeSUT()
        try sut.insert(entries)
        expect(sut, toRetrieve: .success(entries))
        
        try sut.deleteCachedFeed()
        
        XCTAssertThrowsError(try sut.retrieve())
    }
    
    func test_delete_shouldDeliverErrorOnDeletionFailure() {
        
        let sut = makeSUT(storeURL: noDeletePermissionURL())
        
        XCTAssertThrowsError(try sut.deleteCachedFeed())
    }
    
    func test_delete_shouldHaveNoSideEffectsOnDeletionFailure() {
        
        let sut = makeSUT(storeURL: noDeletePermissionURL())
        
        XCTAssertThrowsError(try sut.deleteCachedFeed())
        XCTAssertThrowsError(try sut.retrieve())
    }
    
    // MARK: - Helpers
    
    private typealias SUT = CodableEntryStore
    private typealias RetrievalResult = Result<[Entry], Error>
    
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
    
    private func noDeletePermissionURL() -> URL {
        
        return FileManager.default
            .urls(for: .cachesDirectory, in: .systemDomainMask)
            .first!
    }
    
    private func makeEntries(
        count: Int = .random(in: 1...100)
    ) -> [Entry] {
        
        let items = (0..<count).map { _ in
            
            makeEntry()
        }
        precondition(items.count == count)
        
        return items
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
    
    private func expect(
        _ sut: SUT,
        toRetrieve expectedResult: RetrievalResult,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let retrievedResult = Result { try sut.retrieve() }
        
        switch (expectedResult, retrievedResult) {
        case let (.failure(expectedFailure as SUT.RetrievalFailure), .failure(retrievalFailure as SUT.RetrievalFailure)):
            XCTAssertNoDiff(expectedFailure, retrievalFailure, file: file, line: line)
            
        case let (.success(expected), .success(retrieved)):
            XCTAssertNoDiff(retrieved, expected, file: file, line: line)
            
        default:
            XCTFail("Expected to retrieve \(expectedResult), got \(retrievedResult) instead.", file: file, line: line)
        }
    }
}
