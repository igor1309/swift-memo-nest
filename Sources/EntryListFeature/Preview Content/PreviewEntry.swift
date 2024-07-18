//
//  PreviewEntry.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Foundation

struct PreviewEntry: Equatable, Identifiable {
    
    let id: UUID
    let note: String
    
    init(
        id: UUID = .init(),
        note: String
    ) {
        self.id = id
        self.note = note
    }
}
