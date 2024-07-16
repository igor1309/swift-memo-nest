//
//  EntryListEvent.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

enum EntryListEvent: Equatable {
    
    case load
    case loaded(LoadResult)
}

extension EntryListEvent {
    
    struct LoadFailure: Error, Equatable {}
    typealias LoadResult = Result<[Entry], LoadFailure>
}
