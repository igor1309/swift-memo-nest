//
//  InMemoryStore.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

import Foundation

public actor InMemoryStore<Item>
where Item: Identifiable {
    
    private var items: [Item]?
    
    public init() {}
}

public extension InMemoryStore {
    
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
    
    func retrieve(byID id: Item.ID) throws -> Item? {
        
        guard let items else { throw UninitialisedCacheFailure() }
        
        return items.first(matchingID: id)
    }
    
    struct UninitialisedCacheFailure: Error, Equatable {}
}

public extension InMemoryStore {
    
    func cache(_ item: Item) throws {
        
        guard var items else { throw UninitialisedCacheFailure() }
        
        if let index = items.firstIndex(matchingID: item.id) {
            items[index] = item
        } else {
            items.append(item)
        }
        
        self.items = items
    }
    
    func cache(_ items: [Item]) {
        
        self.items = items
    }
}

public extension InMemoryStore {
    
    func remove(byID id: Item.ID) throws {
        
        guard var items
        else { throw UninitialisedCacheFailure() }
        
        items.removeAll { $0.id == id }
        self.items = items
    }
    
    func clear() {
        
        self.items = nil
    }
}

extension Array where Element: Identifiable {
    
    func first(matchingID id: Element.ID) -> Element? {
        
        return first(where: { $0.id == id })
    }
    
    func firstIndex(matchingID id: Element.ID) -> Index? {
        
        return firstIndex(where: { $0.id == id })
    }
}
