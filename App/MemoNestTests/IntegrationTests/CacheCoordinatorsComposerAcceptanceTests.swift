//
//  CacheCoordinatorsComposerAcceptanceTests.swift
//  MemoNestTests
//
//  Created by Igor Malyarov on 21.07.2024.
//

@testable import MemoNest
import XCTest

final class CacheCoordinatorsComposerAcceptanceTests: XCTestCase {
    
    override func setUp() {
        
        super.setUp()
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        
        super.tearDown()
        undoStoreSideEffects()
    }
    
    func test_load_shouldDeliverFailureOnEmptyStore() async throws {
        
        let (read, _) = makeSUT()
        
        await assertThrowsAsyncError(_ = try await read.load(anyPayload()))
    }
    
    func test_load_shouldDeliverSavedEntry() async throws {
        
        let entry = makeEntry()
        let (read, write) = makeSUT()
        
        try await write.add(entry)
        let retrieved = try await read.load(anyPayload())
        
        XCTAssertNoDiff(retrieved, [entry])
    }
    
    func test_add_shouldBackupEntry() async throws {
        
        let entry = makeEntry()
        let (_, write) = makeSUT()
        
        try await write.add(entry)
        
        let (read, _) = makeSUT()
        let retrieved = try await read.load(anyPayload())
        
        XCTAssertNoDiff(retrieved, [entry])
    }
    
    func test_add_shouldBackupEntries() async throws {
        
        let (entry1, entry2) = (makeEntry(), makeEntry())
        let (_, write) = makeSUT()
        
        try await write.add(entry1)
        try await write.add(entry2)
        
        let (read, _) = makeSUT()
        let retrieved = try await read.load(anyPayload())
        
        XCTAssertNoDiff(retrieved, [entry1, entry2])
    }
    
    func test_edit_shouldBackupEntry() async throws {
        
        let entry = makeEntry()
        let edited = makeEntry(id: entry.id)
        let (_, write) = makeSUT()
        
        try await write.add(entry)
        try await write.edit(edited)
        
        let (read, _) = makeSUT()
        let retrieved = try await read.load(anyPayload())
        
        XCTAssertNoDiff(retrieved, [edited])
    }
    
    func test_edit_shouldBackupEntries() async throws {
        
        let (entry1, entry2) = (makeEntry(), makeEntry())
        let edited1 = makeEntry(id: entry1.id)
        let edited2 = makeEntry(id: entry2.id)
        let (_, write) = makeSUT()
        
        try await write.add(entry1)
        try await write.add(entry2)
        try await write.edit(edited1)
        try await write.edit(edited2)
        
        let (read, _) = makeSUT()
        let retrieved = try await read.load(anyPayload())
        
        XCTAssertNoDiff(retrieved, [edited1, edited2])
    }
    
    func test_delete_shouldBackupEntries() async throws {
        
        let (entry1, entry2) = (makeEntry(), makeEntry())
        let (_, write) = makeSUT()
        
        try await write.add(entry1)
        try await write.add(entry2)
        try await write.delete(entry1)
        
        let (read, _) = makeSUT()
        let retrieved = try await read.load(anyPayload())
        
        XCTAssertNoDiff(retrieved, [entry2])
    }
    
    func test_mix_shouldBackupEntries() async throws {
        
        let entry = makeEntry()
        let (_, write) = makeSUT()
        
        try await write.add(entry)
        
        let (read1, write1) = makeSUT()
        let retrieved1 = try await read1.load(anyPayload())
        
        XCTAssertNoDiff(retrieved1, [entry])
        
        let edited = makeEntry(id: entry.id)
        try await write1.edit(edited)
        
        let (read2, write2) = makeSUT()
        let retrieved2 = try await read2.load(anyPayload())
        
        XCTAssertNoDiff(retrieved2, [edited])
        
        try await write2.delete(edited)
        
        let (read3, write3) = makeSUT()
        let retrieved3 = try await read3.load(anyPayload())
        
        XCTAssertNoDiff(retrieved3, [])
    }
    
    // MARK: - Helpers
    
    private typealias SUT = CacheCoordinatorsComposer
    private typealias Payload = EntryPayload<Entry>
    
    private func makeSUT(
        storeURL: URL? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT.Coordinators {
        
        let sut = SUT(storeURL: storeURL ?? testStoreURL())
        let (read, write) = sut.compose()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(read, file: file, line: line)
        trackForMemoryLeaks(write, file: file, line: line)
        
        return (read, write)
    }
    
    private func makeEntry(
        id: UUID = .init(),
        creationDate: Date = .init(),
        modificationDate: Date = .init(),
        title: String = anyMessage(),
        url: URL? = .init(string: "any-url"),
        note: String = anyMessage(),
        tags: [String] = [anyMessage()]
    ) -> Entry {
        
        return .init(
            id: id,
            creationDate: creationDate,
            modificationDate: modificationDate,
            title: title,
            url: url,
            note: note,
            tags: tags
        )
    }
    
    private func anyPayload(
        lastID: Entry.ID? = nil
    ) -> EntryPayload<Entry> {
        
        return .init(lastID: nil)
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
}
