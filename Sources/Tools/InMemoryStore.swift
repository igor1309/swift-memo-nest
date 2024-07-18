//
//  InMemoryStore.swift
//  
//
//  Created by Igor Malyarov on 18.07.2024.
//

public actor InMemoryStore<Item>
where Item: Identifiable {
    
    private var items: [Item]?
    
    public init() {}
}

public extension InMemoryStore {
    
    func retrieve(
        predicate: (Item) -> Bool
    ) throws -> [Item] {
        
        guard let items
        else { throw PreloadFailure() }
        
        return items.filter(predicate)
    }
    
    struct PreloadFailure: Error, Equatable {}
}

public extension InMemoryStore {
    
    func cache(_ item: Item) throws {
        
        guard var items
        else { throw PreloadFailure() }
        
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
        else { throw PreloadFailure() }
        
        items.removeAll { $0.id == id }
        self.items = items
    }
    
    func clear() {
        
        self.items = nil
    }
}

extension Array where Element: Identifiable {
    
    func firstIndex(matchingID id: Element.ID) -> Index? {
        
        return firstIndex(where: { $0.id == id })
    }
}
