//
//  FlowState.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

import EntryEditorFeature

/// Represents the state of the flow, including the current destination.
struct FlowState: Equatable {
    
    var destination: Destination? = nil
}

extension FlowState {
    
    /// Represents possible destinations within the flow.
    enum Destination: Equatable {
        
        case editor(EntryEditorFeature.Entry?)
    }
}
