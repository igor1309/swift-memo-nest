//
//  ListFlowReducer.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

final class ListFlowReducer {}

extension ListFlowReducer {
    
    func reduce(
        _ state: State,
        _ event: Event
    ) -> (State, Effect?) {
        
        var state = state
        let effect: Effect? = nil
        
        switch event {
        case .addEntry:
            guard state.destination == nil else { fatalError("impossible state") }
            state.modal = .editor
            
        case let .dismiss(dismiss):
            reduce(&state, dismiss)
            
        case let .select(entry):
            state.destination = .detail(entry)
        }
        
        return (state, effect)
    }
}

extension ListFlowReducer {
    
    typealias State = ListFlowState
    typealias Event = ListFlowEvent
    typealias Effect = ListFlowEffect
}

private extension ListFlowReducer {

    func reduce(
        _ state: inout State,
        _ dismiss: Event.Dismiss
    ) {
        switch dismiss {
        case .destination:
            state.destination = nil
        
        case .modal:
            state.modal = nil
        }
    }
}
