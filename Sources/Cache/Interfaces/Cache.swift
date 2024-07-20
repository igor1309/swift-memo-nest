//
//  Cache.swift
//  
//
//  Created by Igor Malyarov on 20.07.2024.
//

public protocol Cache<Entry> {
    
    associatedtype Entry
    
    func cache(_: Entry) async
    func remove(_: Entry) async throws
    func retrieveAll() async throws -> [Entry]
}
