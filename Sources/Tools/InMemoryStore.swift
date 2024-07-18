//
//  InMemoryStore.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

import Foundation

/// A class representing an in-memory store for items.
/// The items must conform to the Identifiable protocol.
public actor InMemoryStore<Item>
where Item: Identifiable {
    
    /// An optional array to hold the items in the store.
    private var items: [Item]?
    
    /// Initialises an empty in-memory store.
    public init() {}
}

public extension InMemoryStore {
    
    /// Retrieves items from the store that match the given predicate.
    /// - Parameters:
    ///   - predicate: A closure that takes an item as its argument and returns a Boolean value indicating whether the item should be included in the returned array.
    ///   - areInIncreasingOrder: An optional closure that takes two items as its arguments and returns a Boolean value indicating the order of the items.
    /// - Throws: `UninitialisedCacheFailure` if the store is uninitialised.
    /// - Returns: An array of items that match the predicate, optionally sorted by the given closure.
    func retrieve(
        predicate: (Item) -> Bool,
        areInIncreasingOrder: ((Item, Item) -> Bool)? = nil
    ) throws -> [Item] {
        
        guard let items else { throw UninitialisedCacheFailure() }
        
        let filtered = items.filter(predicate)
        
        if let areInIncreasingOrder {
            return filtered.sorted(by: areInIncreasingOrder)
        } else {
            return filtered
        }
    }
    
    /// Retrieves an item from the store by its identifier.
    /// - Parameter id: The identifier of the item to retrieve.
    /// - Throws: `UninitialisedCacheFailure` if the store is uninitialised.
    /// - Returns: The item with the specified identifier, or nil if no such item exists.
    func retrieve(byID id: Item.ID) throws -> Item? {
        
        guard let items else { throw UninitialisedCacheFailure() }
        
        return items.first(matchingID: id)
    }
    
    /// An error indicating that the cache has not been initialized.
    struct UninitialisedCacheFailure: Error, Equatable {}
}

public extension InMemoryStore {
    
    /// Caches a single item in the store.
    /// - Parameter item: The item to cache.
    /// - Throws: `UninitialisedCacheFailure` if the store is uninitialised.
    func cache(_ item: Item) throws {
        
        guard var items else { throw UninitialisedCacheFailure() }
        
        if let index = items.firstIndex(matchingID: item.id) {
            items[index] = item
        } else {
            items.append(item)
        }
        
        self.items = items
    }
    
    /// Caches multiple items in the store.
    /// - Parameter items: The array of items to cache.
    func cache(_ items: [Item]) {
        
        self.items = items
    }
}

public extension InMemoryStore {
    
    /// Removes an item from the store by its identifier.
    /// - Parameter id: The identifier of the item to remove.
    /// - Throws: `UninitialisedCacheFailure` if the store is uninitialised.
    func remove(byID id: Item.ID) throws {
        
        guard var items else { throw UninitialisedCacheFailure() }
        
        items.removeAll { $0.id == id }
        self.items = items
    }
    
    /// Clears all items from the store.
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
