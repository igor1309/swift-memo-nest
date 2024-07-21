//
//  ReadCacheCoordinator.swift
//
//
//  Created by Igor Malyarov on 20.07.2024.
//

import CacheInfra

/// A coordinator that manages read operations from a cache and falls back to a retrieval function if necessary.
/// It leverages a `Payload` for filtering and sorting entries and an `Entry` that must be identifiable.
public final class ReadCacheCoordinator<Payload, Entry>
where Payload: Filtering<Entry> & Sorting<Entry>,
      Entry: Identifiable {
    
    /// The cache for entries.
    private let entryCache: EntryCache
    
    /// The retrieval function to fetch entries when they are not available in the cache.
    private let retrieve: Retrieve
    
    /// Initializes the `ReadCacheCoordinator` with the given cache and retrieval function.
    ///
    /// - Parameters:
    ///   - entryCache: A cache for storing and retrieving entries.
    ///   - retrieve: A function that retrieves entries, which can throw an error.
    public init(
        entryCache: EntryCache,
        retrieve: @escaping Retrieve
    ) {
        self.entryCache = entryCache
        self.retrieve = retrieve
    }
    
    /// Typealias for the cache holding entries.
    public typealias EntryCache = InMemoryCache<Entry>
    
    /// Typealias for the retrieval function which fetches entries.
    public typealias Retrieve = () async throws -> [Entry]
}

public extension ReadCacheCoordinator {
    
    /// Attempts to load entries from the cache. If the cache retrieval fails, it falls back to the retrieval function
    /// and caches the results.
    ///
    /// - Parameter payload: The payload used for filtering and sorting entries.
    /// - Returns: An array of entries.
    /// - Throws: An error if the retrieval function fails.
    func load(
        _ payload: Payload
    ) async throws -> [Entry] {
        
        do {
            return try await self.entryCache.retrieve(payload)
        } catch {
            
            let entries = try await self.retrieve()
            await self.entryCache.cache(entries)
            return entries
        }
    }
}
