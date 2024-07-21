//
//  FlowReducer.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

import EntryEditorFeature

/// Responsible for reducing events to state changes and producing effects.
final class FlowReducer {
    
    private let editorReduce: EditorReduce
    
    /// Initialises the reducer with a specific editor reducer function.
    /// - Parameter editorReduce: A function that reduces editor states and events to new states and optional effects.
    init(editorReduce: @escaping EditorReduce) {
        
        self.editorReduce = editorReduce
    }
    
    /// Type alias for the state of the editor flow.
    typealias EditorState = EditorFlowState<EntryEditorFeature.Entry>
    
    /// Type alias for the editor reducer function.
    typealias EditorReduce = (EditorState, Event.EditorEvent) -> (EditorState, Effect.EditorEffect?)
}

extension FlowReducer {
    
    /// Reduces a given state and event to a new state and an optional effect.
    /// - Parameters:
    ///   - state: The current state of the flow.
    ///   - event: The event to reduce.
    /// - Returns: A tuple containing the new state and an optional effect.
    func reduce(
        _ state: State,
        _ event: Event
    ) -> (State, Effect?) {
        
        var state = state
        var effect: Effect?
        
        switch event {
        case .dismissDestination:
            state.destination = nil
            
        case let .editor(event):
            reduce(&state, &effect, with: event)
        }
        
        return (state, effect)
    }
}

extension FlowReducer {
    
    typealias State = FlowState
    typealias Event = FlowEvent
    typealias Effect = FlowEffect
}

private extension FlowReducer {
    
    func reduce(
        _ state: inout State,
        _ effect: inout Effect?,
        with event: Event.EditorEvent
    ) {
        let (editorFlowState, editorFlowEffect) = editorReduce(state.editorFlowState, event)
        
        switch editorFlowState {
        case .none:
            state.destination = .none
            
        case let .editor(entry):
            state.destination = .editor(entry)
        }
        
        effect = editorFlowEffect.map(Effect.editor)
    }
}

private extension FlowState {
    
    var editorFlowState: EditorFlowState<EntryEditorFeature.Entry> {
        
        switch destination {
        case let .editor(entry):
            return .editor(entry)
            
        default:
            return .none
        }
    }
}
