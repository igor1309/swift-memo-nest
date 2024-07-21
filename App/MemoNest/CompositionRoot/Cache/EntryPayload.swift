//
//  EntryPayload.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

import Cache

struct EntryPayload<Entry: Identifiable>: Filtering, Sorting {
    
    let lastID: Entry.ID?
    
    /// Generates a predicate to filter entries.
    /// - Parameter entry: The entry to be filtered.
    /// - Returns: A boolean indicating if the entry satisfies the predicate.
    func predicate(_ entry: Entry) -> Bool {
        
#warning("use Predicate/Filter from module")
        return true
    }
    
    /// Determines the sort order between two entries.
    /// - Parameters:
    ///   - lhs: The left-hand side entry.
    ///   - rhs: The right-hand side entry.
    /// - Returns: A boolean indicating if lhs should be ordered before rhs.
    func areInIncreasingOrder(_ lhs: Entry, _ rhs: Entry) -> Bool {
        
#warning("use Sort from module")
        return true
    }
}

extension EntryPayload: Equatable where Entry: Equatable {}
