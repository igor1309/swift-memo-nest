//
//  WriteCacheCoordinator.swift
//
//
//  Created by Igor Malyarov on 20.07.2024.
//

/// A coordinator that manages writing entries to a cache and backing them up.
///
/// The `WriteCacheCoordinator` class is responsible for adding, editing, and deleting entries
/// in a cache. It ensures that any changes to the cache are also backed up using a specified
/// backup function.
public final class WriteCacheCoordinator<Entry>
where Entry: Identifiable {
    
    /// The cache for storing entries.
    private let entryCache: any EntryCache
    
    /// The backup function to store entries.
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
    /// This method caches the given entry and then performs a backup of all current entries in the cache.
    ///
    /// - Parameter entry: The entry to add to the cache.
    /// - Throws: An error if the backup operation fails.
    func add(_ entry: Entry) async throws {
        
        await entryCache.cache(entry)
        try await backupAll()
    }
    
    /// Edits an existing entry in the cache and backs up all entries.
    ///
    /// This method updates the given entry in the cache and then performs a backup of all current entries in the cache.
    ///
    /// - Parameter entry: The entry to edit in the cache.
    /// - Throws: An error if the backup operation fails.
    func edit(_ entry: Entry) async throws {
        
        await entryCache.cache(entry)
        try await backupAll()
    }
    
    /// Deletes an existing entry from the cache and backs up all entries.
    ///
    /// This method removes the specified entry from the cache and then performs a backup of all current entries in the cache.
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
    /// This method retrieves all current entries from the cache and calls the backup function with these entries.
    ///
    /// - Throws: An error if the backup operation fails.
    func backupAll() async throws {
        
        try await backup(entryCache.retrieveAll())
    }
}
