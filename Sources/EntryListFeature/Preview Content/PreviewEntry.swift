//
//  PreviewEntry.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Foundation

struct PreviewEntry: Equatable, Identifiable {
    
    let id: UUID
    let text: String
    
    init(
        id: UUID,
        text: String
    ) {
        self.id = id
        self.text = text
    }
}
