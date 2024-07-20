//
//  WriteCacheCoordinator.swift
//
//
//  Created by Igor Malyarov on 20.07.2024.
//

/// A coordinator that manages writing entries to a cache and backing them up.
///
/// The `WriteCacheCoordinator` class is responsible for adding, editing, and deleting entries
/// in a cache, as well as backing up these entries using a specified backup function.
public final class WriteCacheCoordinator<Entry>
where Entry: Identifiable {
    
    private let entryCache: any EntryCache
    private let backup: Backup
    
    /// Initialises a new instance of `WriteCacheCoordinator`.
    ///
    /// - Parameters:
    ///   - entryCache: The cache to store entries in.
    ///   - backup: The backup function to call with the current entries.
    public init(
        entryCache: any EntryCache,
        backup: @escaping Backup
    ) {
        self.entryCache = entryCache
        self.backup = backup
    }
    
    /// A typealias for the entry cache, which is a `Cache` of `Entry` objects.
    public typealias EntryCache = Cache<Entry>
    
    /// A typealias for the backup function, which takes an array of `Entry` objects and returns a void promise.
    public typealias Backup = ([Entry]) async -> Void
}

public extension WriteCacheCoordinator {
    
    /// Adds a new entry to the cache and backs up all entries.
    ///
    /// - Parameter entry: The entry to add to the cache.
    /// - Throws: An error if the backup operation fails.
    func add(_ entry: Entry) async throws {
        
        await entryCache.cache(entry)
        try await backupAll()
    }
    
    /// Edits an existing entry in the cache and backs up all entries.
    ///
    /// - Parameter entry: The entry to edit in the cache.
    /// - Throws: An error if the backup operation fails.
    func edit(_ entry: Entry) async throws {
        
        await entryCache.cache(entry)
        try await backupAll()
    }
    
    /// Deletes an existing entry from the cache and backs up all entries.
    ///
    /// - Parameter entry: The entry to delete from the cache.
    /// - Throws: An error if the backup operation fails.
    func delete(_ entry: Entry) async throws {
        
        try await entryCache.remove(entry)
        try await backupAll()
    }
}

private extension WriteCacheCoordinator {
    
    /// Backs up all entries in the cache.
    ///
    /// - Throws: An error if the backup operation fails.
    func backupAll() async throws {
        
        try await backup(entryCache.retrieveAll())
    }
}
