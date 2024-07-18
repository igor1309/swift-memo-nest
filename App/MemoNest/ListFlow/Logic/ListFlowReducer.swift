//
//  ListFlowReducer.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import EntryEditorFeature

final class ListFlowReducer {
    
    private let isValid: IsValid
    
    init(isValid: @escaping IsValid) {
        
        self.isValid = isValid
    }
    
    typealias IsValid = (Entry) -> Bool
}

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
        if case var .detail(detail) = state.destination,
           detail.entry == entry {
            
            detail.modal = .editor(entry)
            state.destination = .detail(detail)
            return
        }
    }
    
    func reduce(
        _ state: inout State,
        save entry: Entry
    ) {
        guard isValid(entry) else {
            
            print("Entry is not valid")
            return
        }
        
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
