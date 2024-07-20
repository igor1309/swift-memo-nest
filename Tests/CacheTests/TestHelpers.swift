//
//  TestHelpers.swift
//
//
//  Created by Igor Malyarov on 20.07.2024.
//

import Cache
import Foundation

struct Entry: Equatable, Identifiable {
    
    let id: UUID
    let value: String
}

struct Payload: Filtering & Sorting {
    
    let value: String
    
    func predicate(_ entry: Entry) -> Bool {
        
        return true
    }
    
    func areInIncreasingOrder(
        _ lhs: Entry,
        _ rhs: Entry
    ) -> Bool {
        
        return true
    }
}

func makeEntry(
    id: UUID = .init(),
    value: String = anyMessage()
) -> Entry {
    
    return .init(id: id, value: value)
}

func makeEntries(
    count: Int = .random(in: 0..<13)
) -> [Entry] {
    
    let entries = (0..<count).map { _ in makeEntry() }
    precondition(entries.count == count)
    
    return entries
}

func anyPayload(
    value: String = anyMessage()
) -> Payload {
    
    return .init(value: value)
}
