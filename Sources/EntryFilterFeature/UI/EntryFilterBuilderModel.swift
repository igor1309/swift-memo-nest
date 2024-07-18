//
//  EntryFilterBuilderModel.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

import IMRx

typealias EntryFilterBuilderModel = RxViewModel<EntryFilterBuilderState, EntryFilterBuilderEvent, EntryFilterBuilderEffect>

enum EntryFilterBuilderEffect: Equatable {}

extension EntryFilterBuilderReducer {
    
    typealias Effect = EntryFilterBuilderEffect
    
    func reduce(
        _ state: State,
        _ event: Event
    ) -> (State, Effect?) {
        
        var state = state
        reduce(state: &state, event: event)
        
        return (state, nil)
    }
}
