//
//  FlowEvent.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

import EntryEditorFeature

/// Represents events that can occur within the flow.
enum FlowEvent: Equatable {
    
    case dismissModal
    case editor(EditorEvent)
    
    /// Type alias for events specific to the editor flow.
    typealias EditorEvent = EditorFlowEvent<EntryEditorFeature.Entry>
}
