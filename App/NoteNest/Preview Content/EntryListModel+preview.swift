//
//  EntryListModel+preview.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Foundation

extension EntryListModel {
    
    static func preview(
        initialState: EntryListResult = .success(.preview())
    ) -> Self {
        
        return .init(
            initialState: .init(result: initialState),
            reduce: { state, _ in (state, nil) },
            handleEffect: { _,_ in }
        )
    }
}
