//
//  CodableStore.swift
//
//
//  Created by Igor Malyarov on 20.07.2024.
//

import Foundation

import Foundation

/// An actor responsible for managing Codable data storage, ensuring thread-safe
/// read and write operations.
public actor CodableStore<T: Codable> {
    
    private let storeURL: URL
    
    /// Initialises a new CodableStore with the given URL.
    /// - Parameter storeURL: The file URL where the data will be stored.
    public init(storeURL: URL) {
        
        self.storeURL = storeURL
    }
}

public extension CodableStore {
    
    /// Retrieves the stored data from the file.
    /// - Returns: The data of type `T` stored at the specified URL.
    /// - Throws: An error if there is an issue reading the data or decoding it.
    func retrieve() throws -> T {
        
        let data = try Data(contentsOf: storeURL)
        return try JSONDecoder().decode(T.self, from: data)
    }
}

public extension CodableStore {
    
    /// Inserts new data into the file, overwriting any existing data.
    /// - Parameter value: The data of type `T` to be stored.
    /// - Throws: An error if there is an issue encoding the data or writing it to the file.
    func insert(_ value: T) throws {
        
        let data = try JSONEncoder().encode(value)
        try data.write(to: storeURL)
    }
}

public extension CodableStore {
    
    /// Deletes all cached entries from the store.
    /// - Throws: An error if there is an issue removing the data.
    func delete() throws {
        
        try FileManager.default.removeItem(at: storeURL)
    }
}
