//
//  WriteCacheCoordinatorIntegrationTests.swift
//
//
//  Created by Igor Malyarov on 20.07.2024.
//

import Cache
import CacheInfra
import XCTest

final class WriteCacheCoordinatorIntegrationTests: XCTestCase {
    
    func test_init_shouldNotCallCollaborators() {
        
        let (sut, entryCache, backupSpy) = makeSUT()
        
        XCTAssertNotNil(entryCache)
        // XCTAssertEqual(entryCache.callCount, 0)
        XCTAssertEqual(backupSpy.callCount, 0)
        XCTAssertNotNil(sut)
    }
    
    func test_addEntry_shouldAddEntryToEmptyCache() async throws {
        
        let new = makeEntry()
        let (sut, entryCache, _) = makeSUT()
        
        try await sut.add(new)
        
        let cachedEntries = try await entryCache.retrieveAll()
        XCTAssertNoDiff(cachedEntries, [new])
    }
    
    func test_addEntry_shouldCallBackupWithUpdatedEntries() async throws {
        
        let new = makeEntry()
        let (sut, _, backupSpy) = makeSUT()
        
        try await sut.add(new)
        
        XCTAssertNoDiff(backupSpy.payloads, [[new]])
    }
    
    func test_addEntry_shouldAddEntryToNonEmptyCache() async throws {
        
        let (item1, item2) = (makeEntry(), makeEntry())
        let (sut, entryCache, _) = makeSUT()
        
        try await sut.add(item1)
        try await sut.add(item2)
        
        let cachedEntries = try await entryCache.retrieveAll()
        XCTAssertNoDiff(cachedEntries, [item1, item2])
    }
    
    func test_addEntry_shouldCallBackupWithUpdatedNonEmptyEntries() async throws {
        
        let (item1, item2) = (makeEntry(), makeEntry())
        let (sut, _, backupSpy) = makeSUT()
        
        try await sut.add(item1)
        try await sut.add(item2)
        
        XCTAssertNoDiff(backupSpy.payloads, [[item1], [item1, item2]])
    }
    
    func test_editEntry_shouldChangeExistingEntryInCache() async throws {
        
        let entries = makeEntries(count: 2)
        let existing = makeEntry(id: entries[0].id)
        let (sut, entryCache, _) = makeSUT()
        try await sut.add(entries[0])
        try await sut.add(entries[1])
        
        try await sut.edit(existing)
        
        let cachedEntries = try await entryCache.retrieveAll()
        XCTAssertNoDiff(cachedEntries, [existing, entries[1]])
        XCTAssertNotEqual(existing, entries[0])
    }
    
    func test_editEntry_shouldCallBackupWithUpdatedEntries() async throws {
        
        let entries = makeEntries(count: 2)
        let existing = makeEntry(id: entries[0].id)
        let (sut, _, backupSpy) = makeSUT()
        try await sut.add(entries[0])
        try await sut.add(entries[1])
        
        try await sut.edit(existing)
        
        XCTAssertNoDiff(backupSpy.payloads, [
            [entries[0]],
            [entries[0], entries[1]],
            [existing, entries[1]],
        ])
    }
    
    func test_deleteEntry_shouldRemoveEntryFromCache() async throws {
        
        let entries = makeEntries(count: 2)
        let (sut, entryCache, _) = makeSUT()
        try await sut.add(entries[0])
        try await sut.add(entries[1])
        
        try await sut.delete(entries[0])
        
        let cachedEntries = try await entryCache.retrieveAll()
        XCTAssertNoDiff(cachedEntries, [entries[1]])
    }
    
    func test_deleteEntry_shouldCallBackupWithUpdatedEntries() async throws {
        
        let entries = makeEntries(count: 2)
        let (sut, _, backupSpy) = makeSUT()
        try await sut.add(entries[0])
        try await sut.add(entries[1])
        
        try await sut.delete(entries[0])
        
        XCTAssertNoDiff(backupSpy.payloads, [
            [entries[0]],
            [entries[0], entries[1]],
            [entries[1]],
        ])
    }
    
    // MARK: - Helpers
    
    private typealias SUT = WriteCacheCoordinator<Entry>
    private typealias EntryCache = Cache<Entry>
    private typealias BackupSpy = CallSpy<[Entry], Void>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: SUT,
        entryCache: any EntryCache,
        backupSpy: BackupSpy
    ) {
        let entryCache = InMemoryCache<Entry>()
        let backupSpy = BackupSpy(stubs: .init(repeating: (), count: 10))
        let sut = SUT(
            entryCache: entryCache,
            backup: backupSpy.call(payload:)
        )
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(entryCache, file: file, line: line)
        trackForMemoryLeaks(backupSpy, file: file, line: line)
        
        return (sut, entryCache, backupSpy)
    }
}
