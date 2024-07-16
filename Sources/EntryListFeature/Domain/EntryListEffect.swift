//
//  EntryListEffect.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

public enum EntryListEffect<Entry: Identifiable>: Equatable {
    
    case load
    case loadMore(after: Entry.ID)
}
