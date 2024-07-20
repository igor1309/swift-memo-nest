//
//  EntryListModel+preview.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Foundation

extension EntryListModel where State == EntryListState<PreviewEntry> {
    
    static func preview(
        initialState: EntryListState<PreviewEntry> = .init()
    ) -> Self {
        
        return .init(
            initialState: initialState,
            reduce: { state, _ in (state, nil) },
            handleEffect: { _,_ in }
        )
    }
}
