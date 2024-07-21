//
//  EditorFlowReducer.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

/// A reducer that handles the state transitions and effects for the editor flow.
final class EditorFlowReducer<Item> {}

extension EditorFlowReducer {
    
    /// Reduces the state based on the given event and returns the new state and optional effect.
    ///
    /// - Parameters:
    ///   - state: The current state of the editor flow.
    ///   - event: The event that triggers a state transition.
    /// - Returns: A tuple containing the new state and an optional effect.
    func reduce(
        _ state: State,
        _ event: Event
    ) -> (State, Effect?) {
        
        var state = state
        var effect: Effect?
        
        switch event {
        case .complete:
            guard case .editor = state else { break }
            
            state = .none
            
        case let .doneEditing(item):
            guard case .editor = state else { break }
            
            effect = item.map(Effect.edited)
            
        case let .edit(item):
            guard case .none = state else { break }
            
            state = .editor(item)
        }
        
        return (state, effect)
    }
}

extension EditorFlowReducer {
    
    typealias State = EditorFlowState<Item>
    typealias Event = EditorFlowEvent<Item>
    typealias Effect = EditorFlowEffect<Item>
}
