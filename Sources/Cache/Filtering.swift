//
//  Filtering.swift
//
//
//  Created by Igor Malyarov on 20.07.2024.
//

public protocol Filtering<Item> {
    
    associatedtype Item
    
    func predicate(_: Item) -> Bool
}
