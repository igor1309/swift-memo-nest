//
//  EntryStateWrapperListView.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

#if canImport(SwiftUI)
import SwiftUI
import UIPrimitives

public struct EntryStateWrapperListView<Entry: Identifiable, EntryView: View>: View {
    
    @StateObject private var model: Model
    
    private let entryView: (Entry) -> EntryView
    
    public init(
        model: Model,
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
    
    public typealias Model = EntryListModel<Entry>
}
#endif
