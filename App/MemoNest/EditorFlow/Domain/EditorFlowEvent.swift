//
//  EditorFlowEvent.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

/// Represents the possible events that can occur in the editor flow.
enum EditorFlowEvent<Item> {
    
    case complete
    case doneEditing(Item?)
    case edit(Item?)
}

extension EditorFlowEvent: Equatable where Item: Equatable {}
