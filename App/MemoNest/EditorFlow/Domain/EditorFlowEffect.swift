//
//  EditorFlowEffect.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

/// Represents the possible effects that can result from the editor flow.
enum EditorFlowEffect<Item> {
    
    case edited(Item)
}

extension EditorFlowEffect: Equatable where Item: Equatable {}
