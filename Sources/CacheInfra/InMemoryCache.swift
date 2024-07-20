//
//  InMemoryCache.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

import Foundation

/// A class representing an in-memory cache for items.
/// The items must conform to the Identifiable protocol.
public actor InMemoryCache<Item>
where Item: Identifiable {
    
    /// An optional array to hold the items in the cache.
    private var items: [Item]?
    
    /// Initialises an empty in-memory cache.
    public init() {}
}

public extension InMemoryCache {
    
    /// Retrieves items from the cache that match the given predicate.
    /// - Parameters:
    ///   - predicate: A closure that takes an item as its argument and returns a Boolean value indicating whether the item should be included in the returned array.
    ///   - areInIncreasingOrder: An optional closure that takes two items as its arguments and returns a Boolean value indicating the order of the items.
    /// - Throws: `UninitialisedCacheFailure` if the cache is uninitialised.
    /// - Returns: An array of items that match the predicate, optionally sorted by the given closure.
    func retrieve(
        predicate: ((Item) -> Bool)?,
        areInIncreasingOrder: ((Item, Item) -> Bool)?
    ) throws -> [Item] {
        
        guard let items else { throw UninitialisedCacheFailure() }
        
        #warning("improve tests to cover all cases")
        switch (predicate, areInIncreasingOrder) {
        case (.none, .none):
            return items
            
        case let (.some(predicate), .none):
            return items.filter(predicate)
            
        case let (.none, .some(areInIncreasingOrder)):
            return items.sorted(by: areInIncreasingOrder)
            
        case let (.some(predicate), .some(areInIncreasingOrder)):
            return items
                .filter(predicate)
                .sorted(by: areInIncreasingOrder)
        }
    }
    
    /// Retrieves an item from the cache by its identifier.
    /// - Parameter id: The identifier of the item to retrieve.
    /// - Throws: `UninitialisedCacheFailure` if the cache is uninitialised.
    /// - Returns: The item with the specified identifier, or nil if no such item exists.
    func retrieve(byID id: Item.ID) throws -> Item? {
        
        guard let items else { throw UninitialisedCacheFailure() }
        
        return items.first(matchingID: id)
    }
    
    /// An error indicating that the cache has not been initialised.
    struct UninitialisedCacheFailure: Error, Equatable {}
}

public extension InMemoryCache {
    
    /// Caches a single item in the cache.
    /// - Parameter item: The item to cache.
    func cache(_ item: Item) {
        
        guard var items else {
            
            self.items = [item]
            return
        }
        
        if let index = items.firstIndex(matchingID: item.id) {
            items[index] = item
        } else {
            items.append(item)
        }
        
        self.items = items
    }
    
    /// Replace items in the cache.
    /// - Parameter items: The array of items to cache.
    func cache(_ items: [Item]) {
        
        self.items = items
    }
}

public extension InMemoryCache {
    
    /// Removes an item from the cache by its identifier.
    /// - Parameter id: The identifier of the item to remove.
    /// - Throws: `UninitialisedCacheFailure` if the cache is uninitialised.
    func remove(byID id: Item.ID) throws {
        
        guard var items else { throw UninitialisedCacheFailure() }
        
        items.removeAll { $0.id == id }
        self.items = items
    }
    
    /// Clears all items from the cache.
    func clear() {
        
        self.items = nil
    }
}

extension Array where Element: Identifiable {
    
    /// Finds the first element in the array with the specified identifier.
    /// - Parameter id: The identifier to match.
    /// - Returns: The first element that matches the identifier, or nil if no such element exists.
    func first(matchingID id: Element.ID) -> Element? {
        
        return first(where: { $0.id == id })
    }
    
    /// Finds the index of the first element in the array with the specified identifier.
    /// - Parameter id: The identifier to match.
    /// - Returns: The index of the first element that matches the identifier, or nil if no such element exists.
    func firstIndex(matchingID id: Element.ID) -> Index? {
        
        return firstIndex(where: { $0.id == id })
    }
}
