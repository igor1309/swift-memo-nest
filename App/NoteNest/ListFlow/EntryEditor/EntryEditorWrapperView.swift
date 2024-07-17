//
//  EntryEditorWrapperView.swift
//  NoteNest
//
//  Created by Igor Malyarov on 17.07.2024.
//

import EntryEditorFeature
import SwiftUI

struct EntryEditorWrapperView: View {
    
    @State private var entry: Entry
    
    let onCancel: () -> Void
    let onSave: (Entry) -> Void
    
    init(
        entry: Entry = .empty,
        onCancel: @escaping () -> Void,
        onSave: @escaping (Entry) -> Void
    ) {
        self._entry = .init(initialValue: entry)
        self.onCancel = onCancel
        self.onSave = onSave
    }
    
    typealias Entry = EntryEditorFeature.Entry
    
    var body: some View {
        NavigationStack {
            
            EntryEditor(entry: $entry)
                .navigationTitle("Entry Editor")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    
                    ToolbarItem(placement: .cancellationAction) {
                        
                        Button("Cancel", action: onCancel)
                    }
                    
                    ToolbarItem(placement: .confirmationAction) {
                        
#warning("or update if editing existing")
                        Button("Save") { onSave(entry) }
                        //   .disabled(!node.canSave)
                    }
                }
        }
    }
}

extension EntryEditorFeature.Entry {
    
    static let empty: Self = .init()
}
