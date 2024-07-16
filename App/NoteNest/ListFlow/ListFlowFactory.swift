//
//  ListFlowFactory.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import EntryListFeature
import SwiftUI

final class ListFlowFactory {
    
    private let model: Model
    
    init(model: Model) {
        
        self.model = model
    }
    
    typealias Model = EntryListModel<Entry>
}

extension ListFlowFactory {
    
    func makeEntryListView(
        entryView: @escaping (Entry) -> some View
    ) -> some View {
        
        EntryStateWrapperListView(model: model, entryView: entryView)
    }
}
