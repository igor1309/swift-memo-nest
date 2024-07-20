//
//  EntryListState.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

public struct EntryListState<Entry: Identifiable> {
    
    public var result: EntryListResult<Entry>?
    public var status: Status?
    
    public init(
        result: EntryListResult<Entry>? = nil,
        status: Status? = nil
    ) {
        self.result = result
        self.status = status
    }
}

public typealias EntryListResult<Entry: Identifiable> = Result<[Entry], EntryListEvent<Entry>.LoadFailure>

public extension EntryListState {
    
    enum Status: Equatable {
        
        case inflight
    }
}

extension EntryListState: Equatable where Entry: Equatable {}
