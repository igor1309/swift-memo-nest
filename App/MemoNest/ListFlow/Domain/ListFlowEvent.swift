//
//  ListFlowEvent.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import EntryListFeature

enum ListFlowEvent: Equatable {
    
    case addEntry
    case dismiss(Dismiss)
    case edit(Entry)
    case select(Entry)
    case save(Entry)
}

extension ListFlowEvent {
    
    enum Dismiss: Equatable {
 
        case destination, modal, destinationModal
    }
}
