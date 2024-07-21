//
//  EditorFlowStateWrapperView.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

import EntryEditorFeature
import SwiftUI

struct EditorFlowStateWrapperView: View {
    
    @State private var entry: Entry
    
    private let event: (Entry?) -> Void
    
    init(
        entry: Entry?,
        event: @escaping (Entry?) -> Void
    ) {
        self._entry = .init(initialValue: entry ?? .init())
        self.event = event
    }
    
    var body: some View {
        
        EntryEditor(entry: $entry)
            .navigationTitle("EntryEditor")
            .toolbar {
                
                ToolbarItem(placement: .cancellationAction) {
                    
                    Button("Cancel") { event(nil) }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    
                    Button("Save") { event(entry) }
                }
            }
    }
}

extension EditorFlowStateWrapperView {
    
    typealias Entry = EntryEditorFeature.Entry
    typealias Model = FlowModel
}
