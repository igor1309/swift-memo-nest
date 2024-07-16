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
            effect = .load
            
        case let .loaded(result):
            reduce(&state, with: result)
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
        switch result {
        case let .failure(failure):
            state = .failure(failure)
            
        case let .success(entries):
            state = .success(entries)
        }
    }
}
