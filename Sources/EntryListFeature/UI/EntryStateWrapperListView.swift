//
//  EntryStateWrapperListView.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

#if canImport(SwiftUI)
import SwiftUI
import UIPrimitives

public struct EntryStateWrapperListView<EntryView: View>: View {
    
    @StateObject private var model: EntryListModel
    
    private let entryView: (Entry) -> EntryView
    
    public init(
        model: EntryListModel,
        entryView: @escaping (Entry) -> EntryView
    ) {
        self._model = .init(wrappedValue: model)
        self.entryView = entryView
    }
    
    public var body: some View {
        
        EntryListView(
            state: model.state,
            event: model.event(_:),
            entryView: entryView
        )
    }
}
#endif
