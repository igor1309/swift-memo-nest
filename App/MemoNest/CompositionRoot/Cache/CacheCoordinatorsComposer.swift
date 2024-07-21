//
//  CacheCoordinatorsComposer.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

import Cache
import CacheInfra
import Foundation

final class CacheCoordinatorsComposer {
    
    private let storeURL: URL
    
    /// Initialises the composer with a store URL.
    /// - Parameter storeURL: The URL of the store.
    init(storeURL: URL) {
        
        self.storeURL = storeURL
    }
}

extension CacheCoordinatorsComposer {
    
    /// Composes the read and write coordinators.
    /// - Returns: A tuple containing the read and write coordinators.
    func compose() -> Coordinators {
        
        let cache = InMemoryCache<Entry>()
        let persistence = CodableStore<[CodableEntry]>(storeURL: storeURL)
        
        let read = ReadCoordinator(
            entryCache: cache,
            retrieve: { try await persistence.adaptedRetrieve() }
        )
        let write = WriteCoordinator(
            entryCache: cache,
            backup: { try? await persistence.adaptedInsert($0) }
        )
        
        return (read, write)
    }
    
    typealias ReadCoordinator = ReadCacheCoordinator<EntryPayload<Entry>, Entry>
    typealias WriteCoordinator = WriteCacheCoordinator<Entry>
    typealias Coordinators = (ReadCoordinator, WriteCoordinator)
}

private struct CodableEntry: Codable {
    
    let id: UUID
    let creationDate: Date
    let modificationDate: Date
    let title: String
    let url: URL?
    let note: String
    let tags: [String]
    
    var entry: Entry {
        
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
}

private extension Entry {
    
    var codable: CodableEntry {
        
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
}

private extension CodableStore where T == [CodableEntry] {
    
    func adaptedRetrieve() throws -> [Entry] {
        
        try retrieve().map(\.entry)
    }
    
    func adaptedInsert(
        _ entries: [Entry]
    ) throws {
        
        try insert(entries.map(\.codable))
    }
}
