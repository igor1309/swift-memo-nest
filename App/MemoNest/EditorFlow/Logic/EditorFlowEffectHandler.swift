//
//  EditorFlowEffectHandler.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

/// A generic effect handler for editor flow, which processes items and dispatches events.
final class EditorFlowEffectHandler<Item> {
    
    /// The closure that handles items.
    private let handleItem: HandleItem
    
    /// Initialises the effect handler with a given item handler.
    ///
    /// - Parameter handleItem: The closure that processes items and calls a completion callback.
    init(handleItem: @escaping HandleItem) {
        
        self.handleItem = handleItem
    }
    
    /// A closure type alias for handling items with a completion callback.
    typealias HandleItem = (Item, @escaping () -> Void) -> Void
}

extension EditorFlowEffectHandler {
    
    /// Handles an effect by processing the associated item and dispatching an event upon completion.
    ///
    /// - Parameters:
    ///   - effect: The effect to handle.
    ///   - dispatch: The closure to dispatch events.
    func handleEffect(
        _ effect: Effect,
        _ dispatch: @escaping Dispatch
    ) {
        switch effect {
        case let .edited(item):
            handleItem(item) { dispatch(.complete) }
        }
    }
}

extension EditorFlowEffectHandler {
    
    /// A closure type alias for dispatching events.
    typealias Dispatch = (Event) -> Void
    
    /// Type alias for events related to the editor flow.
    typealias Event = EditorFlowEvent<Item>

    /// Type alias for effects related to the editor flow.
    typealias Effect = EditorFlowEffect<Item>
}
