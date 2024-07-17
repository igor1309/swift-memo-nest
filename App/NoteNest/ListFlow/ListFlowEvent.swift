//
//  ListFlowEvent.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import EntryEditorFeature
import EntryListFeature

enum ListFlowEvent: Equatable {
    
    case addEntry
    case dismiss(Dismiss)
    case select(Entry)
    case save(EntryEditorFeature.Entry)
}

extension ListFlowEvent {
    
    enum Dismiss: Equatable {
 
        case destination, modal
    }
}
