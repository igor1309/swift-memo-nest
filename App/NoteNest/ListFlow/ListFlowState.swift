//
//  ListFlowState.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import EntryListFeature

struct ListFlowState: Equatable {
    
    var destination: Destination? = nil
    var modal: Modal? = nil
}

extension ListFlowState {
    
    enum Destination: Equatable {
        
        case detail(Entry)
    }
    
    enum Modal: Equatable {
        
        case editor
    }
}
