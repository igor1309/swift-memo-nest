//
//  EntryListState.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

struct EntryListState: Equatable {
    
    var result: EntryListResult
    var status: Status?
}

typealias EntryListResult = Result<[Entry], EntryListEvent.LoadFailure>

extension EntryListState {
    
    enum Status: Equatable {
        
        case inflight
    }
}
