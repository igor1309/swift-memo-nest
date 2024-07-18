//
//  ListFlowEffectHandler.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Foundation

final class ListFlowEffectHandler {}

extension ListFlowEffectHandler {
    
    func handleEffect(
        _ effect: Effect,
        _ dispatch: @escaping Dispatch
    ) {
        switch effect {
            
        }
    }
}

extension ListFlowEffectHandler {
    
    typealias Dispatch = (Event) -> Void
    
    typealias Event = ListFlowEvent
    typealias Effect = ListFlowEffect
}
