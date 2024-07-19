//
//  CodableEntryStore.swift
//  
//
//  Created by Igor Malyarov on 19.07.2024.
//

import Foundation

public final class CodableEntryStore {
    
    private let storeURL: URL
    
    public init(storeURL: URL) {
        
        self.storeURL = storeURL
    }
}

public extension CodableEntryStore {
    
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

public extension CodableEntryStore {
    
    func insert(_ entries: [Entry]) throws {
        
        let cache = entries.map { Cache(entry: $0) }
        let encoder = JSONEncoder()
        let encoded = try encoder.encode(cache)
        try encoded.write(to: storeURL)
    }
}

public extension CodableEntryStore {
    
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
