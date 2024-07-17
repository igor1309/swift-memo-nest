//
//  EntryListEvent.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

public enum EntryListEvent<Entry: Identifiable> {
    
    case load
    case loaded(LoadResult)
    case loadMore(after: Entry.ID)
    case save(Entry)
}

extension EntryListEvent {
    
    public struct LoadFailure: Error, Equatable {
        
        public init() {}
    }
    
    public typealias LoadResult = Result<[Entry], LoadFailure>
}

extension EntryListEvent: Equatable where Entry: Equatable {}
