//
//  ReadCacheCoordinator.swift
//
//
//  Created by Igor Malyarov on 20.07.2024.
//

import CacheInfra
import Tools

/// A coordinator that manages read operations from an in-memory cache and falls back to a retrieval function if necessary.
/// It leverages a `Payload` for filtering and sorting entries and an `Entry` that must be identifiable.
public final class ReadCacheCoordinator<Payload, Entry>
where Payload: Filtering<Entry> & Sorting<Entry>,
      Entry: Identifiable {
    
    /// The in-memory cache for entries.
    private let entryCache: EntryCache
    
    /// The retrieval function to fetch entries when they are not available in the cache.
    private let retrieve: Retrieve
    
    /// Initialises the ReadCacheCoordinator with the given cache and retrieval function.
    ///
    /// - Parameters:
    ///   - entryCache: An in-memory cache for storing and retrieving entries.
    ///   - retrieve: A function that retrieves entries, which can throw an error.
    public init(
        entryCache: EntryCache,
        retrieve: @escaping Retrieve
    ) {
        self.entryCache = entryCache
        self.retrieve = retrieve
    }
    
    /// Typealias for the in-memory cache holding entries.
    public typealias EntryCache = InMemoryCache<Entry>
    
    /// Typealias for the retrieval function which fetches entries.
    public typealias Retrieve = () throws -> [Entry]
}

extension ReadCacheCoordinator: Loader {
    
    /// Loads entries based on the given payload. It attempts to retrieve entries from the cache first,
    /// and falls back to the retrieval function if necessary.
    ///
    /// - Parameters:
    ///   - payload: The payload used for filtering and sorting entries.
    ///   - completion: A completion handler that receives the result of the load operation.
    public func load(
        _ payload: Payload,
        _ completion: @escaping LoadCompletion
    ) {
        Task { [weak self] in
            guard let self else { return }
            completion(await self.loadWithFallback(payload))
        }
    }
    
    /// Typealias for the successful result containing an array of entries.
    public typealias Success = [Entry]
    
    /// Typealias for the failure result containing an error.
    public typealias Failure = Error
}

private extension ReadCacheCoordinator {
    
    /// Attempts to load entries from the cache. If the cache retrieval fails, it falls back to the retrieval function
    /// and caches the results.
    ///
    /// - Parameter payload: The payload used for filtering and sorting entries.
    /// - Returns: A result containing either an array of entries or an error.
    func loadWithFallback(
        _ payload: Payload
    ) async -> Result<[Entry], Error> {
        do {
            let entries = try await self.entryCache.retrieve(payload)
            return .success(entries)
        } catch {
            let result = Result { try self.retrieve() }
            try? await self.entryCache.cache(result.get())
            return result
        }
    }
}

extension InMemoryCache {
    
    func retrieve<Payload>(
        _ payload: Payload
    ) throws -> [Item] where Payload: Filtering<Item> & Sorting<Item> {
        
#warning("restore `areInIncreasingOrder` line")
        return try retrieve(
            predicate: payload.predicate(_:),
            areInIncreasingOrder: nil
            // areInIncreasingOrder: payload.areInIncreasingOrder(_:_:)
        )
    }
    //    func retrieve<Payload>(
    //        payload: Payload
    //    ) throws -> [Item] where Payload: Filtering<Item> & Sorting<Item> {
    //
    //#warning("restore `areInIncreasingOrder` line")
    //        return try retrieve(
    //            predicate: payload.predicate(_:),
    //            areInIncreasingOrder: nil
    //            // areInIncreasingOrder: payload.areInIncreasingOrder(_:_:)
    //        )
    //    }
}
