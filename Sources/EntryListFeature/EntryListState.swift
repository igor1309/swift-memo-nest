//
//  EntryListState.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

public struct EntryListState: Equatable {
    
    public var result: EntryListResult?
    public var status: Status?
    
    public init(
        result: EntryListResult? = nil, 
        status: Status? = nil
    ) {
        self.result = result
        self.status = status
    }
}

public typealias EntryListResult = Result<[Entry], EntryListEvent.LoadFailure>

public extension EntryListState {
    
    enum Status: Equatable {
        
        case inflight
    }
}
