//
//  ListFlowViewFactory.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import EntryListFeature
import SwiftUI

final class ListFlowViewFactory {}

extension ListFlowViewFactory {
    
    func makeEntryListView(
        model: EntryListModel<Entry>,
        entryView: @escaping (Entry) -> some View
    ) -> some View {
        
        EntryStateWrapperListView(model: model, entryView: entryView)
    }
}
