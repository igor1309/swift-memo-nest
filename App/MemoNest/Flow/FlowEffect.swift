//
//  FlowEffect.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

import EntryEditorFeature

/// Represents effects that can occur as a result of events within the flow.
enum FlowEffect: Equatable {
    
    case editor(EditorEffect)
    
    /// Type alias for effects specific to the editor flow.
    typealias EditorEffect = EditorFlowEffect<EntryEditorFeature.Entry>
}
