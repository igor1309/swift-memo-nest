//
//  WriteCacheCoordinator.swift
//
//
//  Created by Igor Malyarov on 20.07.2024.
//

public final class WriteCacheCoordinator<Entry>
where Entry: Identifiable {
    
    private let entryCache: any EntryCache
    private let backup: Backup
    
    public init(
        entryCache: any EntryCache,
        backup: @escaping Backup
    ) {
        self.entryCache = entryCache
        self.backup = backup
    }
    
    public typealias EntryCache = Cache<Entry>
    public typealias Backup = ([Entry]) async -> Void
}

public extension WriteCacheCoordinator {
    
    func add(_ entry: Entry) async throws {
        
        await entryCache.cache(entry)
        try await backupAll()
    }
    
    func edit(_ entry: Entry) async throws {
        
        await entryCache.cache(entry)
        try await backupAll()
    }
    
    func delete(_ entry: Entry) async throws {
        
        try await entryCache.remove(entry)
        try await backupAll()
    }
}

private extension WriteCacheCoordinator {
    
    func backupAll() async throws {
        
        try await backup(entryCache.retrieveAll())
    }
}
