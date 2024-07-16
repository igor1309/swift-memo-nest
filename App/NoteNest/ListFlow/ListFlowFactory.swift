//
//  ListFlowFactory.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import EntryListFeature
import SwiftUI

final class ListFlowFactory {
    
    private let model: EntryListModel
    
    init(model: EntryListModel) {
        
        self.model = model
    }
}

extension ListFlowFactory {
    
    func makeEntryListView(
        entryView: @escaping (Entry) -> some View
    ) -> some View {
        
        EntryListView(model: model, entryView: entryView)
    }
}
