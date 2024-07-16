//
//  Entry.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Foundation

public struct Entry: Equatable, Identifiable {
    
    public let id: UUID
    public let text: String
    
    public init(
        id: UUID, 
        text: String
    ) {
        self.id = id
        self.text = text
    }
}
