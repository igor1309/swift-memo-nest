//
//  EntryListModel+preview.swift
//  MemoNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import EntryListFeature
import Foundation

extension EntryListModel where State == EntryListState<Entry> {
    
    static func preview(
        initialState: EntryListState<Entry> = .init()
    ) -> Self {
        
        return .init(
            initialState: initialState,
            reduce: { state, _ in (state, nil) },
            handleEffect: { _,_ in }
        )
    }
}
