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
            
        case let .edit(entry):
            reduce(&state, edit: entry)
            
        case let .select(entry):
            state.destination = .detail(.init(entry: entry))
            
        case let .save(entry):
            reduce(&state, save: entry)
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
            
        case .destinationModal:
            state.destination?.detailModal = nil
        }
    }
    
    func reduce(
        _ state: inout State,
        edit entry: Entry
    ) {
        print("TBD: edit entry", entry)
        if case var .detail(detail) = state.destination,
           detail.entry == entry {
            
            detail.modal = .editor(entry)
            state.destination = .detail(detail)
            return
        }
        
        // else { fatalError("impossible state") }
    }
    
    func reduce(
        _ state: inout State,
        save entry: Entry
    ) {
#warning("add validation?")
        state.content.event(.save(entry))
        
        if state.modal == .editor {
            
            state.modal = .none
        }
        
        if case let .detail(detail) = state.destination,
           case .editor = detail.modal {
            
            state.destination = .detail(.init(entry: entry))
        }
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

private extension ListFlowState.Destination {
    
    var detailModal: Detail.Modal? {
        
        get {
            switch self {
            case let .detail(detail):
                return detail.modal
            }
        }
        
        set {
            guard case var .detail(detail) = self
            else { return }
            
            detail.modal = newValue
            self = .detail(detail)
        }
    }
}
