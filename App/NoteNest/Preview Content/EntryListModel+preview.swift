//
//  EntryListModel+preview.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Foundation

extension EntryListModel {
    
    static func preview(
        initialState: [Entry] = .preview
    ) -> Self {
        
        return .init(
            initialState: initialState,
            reduce: { state, _ in (state, nil) },
            handleEffect: { _,_ in }
        )
    }
}

extension Array where Element == Entry {
    
    static let preview: Self = (0..<10).map { _ in
    
        return .init(
            id: UUID(),
            text: UUID().uuidString
        )
    }
}
