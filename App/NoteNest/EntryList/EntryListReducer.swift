//
//  EntryListReducer.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

final class EntryListReducer {}

extension EntryListReducer {
    
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
            
        case .loadMore:
            print("load more")
        }
        
        return (state, effect)
    }
}

extension EntryListReducer {
    
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
            state.result = .failure(failure)
            
        case let .success(entries):
            state.result = .success(entries)
        }
    }
}
