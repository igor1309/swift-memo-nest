//
//  EditorFlowState.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

/// Represents the possible states of the editor flow.
enum EditorFlowState<Item> {
    
    case none
    case editor(Item?)
}

extension EditorFlowState: Equatable where Item: Equatable {}
