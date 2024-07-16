//
//  EntryListReducer.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

public final class EntryListReducer {
    
    public init() {}
}

public extension EntryListReducer {
    
    func reduce(
        _ state: State,
        _ event: Event
    ) -> (State, Effect?) {
        
        var state = state
        var effect: Effect?
        
        switch event {
        case .load:
            state.status = .inflight
            effect = .load
            
        case let .loaded(result):
            reduce(&state, with: result)
            
        case let .loadMore(after: id):
            state.status = .inflight
            effect = .loadMore(after: id)
        }
        
        return (state, effect)
    }
}

public extension EntryListReducer {
    
    typealias State = EntryListState
    typealias Event = EntryListEvent
    typealias Effect = EntryListEffect
}

private extension EntryListReducer {
    
    func reduce(
        _ state: inout State,
        with result: Event.LoadResult
    ) {
        state.status = nil
        
        switch result {
        case let .failure(failure):
            switch state.result {
            case .none:
                state.result = .failure(failure)
                
            case .failure, .success:
                // ???
                break
            }
            
        case let .success(entries):
            switch state.result {
            case .none, .failure:
                state.result = .success(entries)
                
            case var .success(existingEntries):
                existingEntries += entries
                state.result = .success(existingEntries)
            }
        }
    }
}
