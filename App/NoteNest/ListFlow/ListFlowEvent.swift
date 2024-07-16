//
//  ListFlowEvent.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

enum ListFlowEvent: Equatable {
    
    case dismiss(Dismiss)
}

extension ListFlowEvent {
    
    enum Dismiss: Equatable {
 
        case destination
    }
}
