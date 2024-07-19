//
//  CodableEntryStore.swift
//
//
//  Created by Igor Malyarov on 19.07.2024.
//

import Foundation

/// A class responsible for storing and managing entries in a Codable format.
public final class CodableEntryStore {
    
    /// The URL where the entries are stored.
    private let storeURL: URL
    
    /// Initialises a new instance of `CodableEntryStore` with a given URL.
    /// - Parameter storeURL: The URL where the entries will be stored.
    public init(storeURL: URL) {
        
        self.storeURL = storeURL
    }
}

public extension CodableEntryStore {
    
    /// Retrieves all the stored entries.
    /// - Returns: An array of `Entry` objects.
    /// - Throws: `RetrievalFailure` if there is an error reading or decoding the data.
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
    
    /// An error type indicating a failure in retrieving the entries.
    struct RetrievalFailure: Error, Equatable {}
}

public extension CodableEntryStore {
    
    /// Inserts an array of entries into the store.
    /// - Parameter entries: The entries to be inserted.
    /// - Throws: An error if there is an issue encoding or writing the data.
    func insert(_ entries: [Entry]) throws {
        
        let cache = entries.map { Cache(entry: $0) }
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(cache)
        try encoded.write(to: storeURL)
    }
}

public extension CodableEntryStore {
    
    /// Deletes all cached entries from the store.
    /// - Throws: An error if there is an issue removing the data.
    func deleteCachedFeed() throws {
        
        try FileManager.default.removeItem(at: storeURL)
    }
}

private extension CodableEntryStore {
    
    /// A structure representing a cache entry.
    struct Cache: Codable {
        
        let id: UUID
        let creationDate: Date
        let modificationDate: Date
        let title: String
        let url: URL?
        let note: String
        let tags: [String]
        
        /// Initialises a new instance of `Cache` from an `Entry`.
        /// - Parameter entry: The entry to be cached.
        init(entry: Entry) {
            
            self.id = entry.id
            self.creationDate = entry.creationDate
            self.modificationDate = entry.modificationDate
            self.title = entry.title
            self.url = entry.url
            self.note = entry.note
            self.tags = entry.tags
        }
        
        /// Converts the cache entry back to an `Entry`.
        var entry: Entry {
            
            return .init(id: id, creationDate: creationDate, modificationDate: modificationDate, title: title, url: url, note: note, tags: tags)
        }
    }
}
