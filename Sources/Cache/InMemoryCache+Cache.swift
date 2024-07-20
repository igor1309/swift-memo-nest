//
//  InMemoryCache+Cache.swift
//  
//
//  Created by Igor Malyarov on 20.07.2024.
//

import CacheInfra

extension InMemoryCache: Cache {
    
    public func remove(_ item : Item) async throws {
        
        try remove(byID: item.id)
    }
}
