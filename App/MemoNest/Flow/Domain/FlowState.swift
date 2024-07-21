//
//  FlowState.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

import EntryEditorFeature

/// Represents the state of the flow, including the current destination.
struct FlowState: Equatable {
    
    var modal: Modal? = nil
}

extension FlowState {
    
    /// Represents possible destinations within the flow.
    enum Modal: Equatable {
        
        case editor(EntryEditorFeature.Entry?)
    }
}
