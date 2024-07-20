//
//  Sorting.swift
//  
//
//  Created by Igor Malyarov on 20.07.2024.
//

public protocol Sorting<Item> {
    
    associatedtype Item
    
    func areInIncreasingOrder(_: Item, _: Item) -> Bool
}
