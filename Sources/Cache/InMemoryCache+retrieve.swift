//
//  InMemoryCache+retrieve.swift
//  
//
//  Created by Igor Malyarov on 20.07.2024.
//

import CacheInfra

public extension InMemoryCache {
    
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

