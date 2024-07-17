//
//  ListFlowReducer.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import EntryEditorFeature

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
            guard state.destination == nil 
            else { fatalError("impossible state") }
            
            state.modal = .editor
            
        case let .dismiss(dismiss):
            reduce(&state, dismiss)
            
        case let .select(entry):
            state.destination = .detail(entry)
            
        case let .save(entry):
            reduce(&state, entry)
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

    func reduce(
        _ state: inout State,
        _ entry: EntryEditorFeature.Entry
    ) {
        guard case .editor = state.modal
        else { fatalError("impossible state") }
        
        #warning("add validation?")
        state.content.event(.save(.init(entry)))
        state.modal = .none
    }
}

private extension Entry {
    
    init(_ entry: EntryEditorFeature.Entry) {
        
        self.init(
            id: .init(),
            title: entry.title,
            url: entry.url,
            text: entry.note,
            tags: entry.tags
        )
    }
}
