//
//  EntryEditorWrapperView.swift
//  MemoNest
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
    
    var body: some View {
        NavigationStack {
            
            EntryEditor(entry: $entry.editorEntry)
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

// MARK: - Adapters

extension Binding where Value == Entry {
    
    var editorEntry: Binding<EntryEditorFeature.Entry> {
        
        return .init(
            get: {
                return .init(
                    title: wrappedValue.title,
                    url: wrappedValue.url,
                    note: wrappedValue.note,
                    tags: wrappedValue.tags
                )
            },
            set: {
                self.wrappedValue = .init(
                    id: wrappedValue.id,
                    creationDate: wrappedValue.creationDate,
                    modificationDate: .init(),
                    title: $0.title,
                    url: $0.url,
                    note: $0.note,
                    tags: $0.tags
                )
            }
        )
    }
}

// MARK: - Helpers

extension Entry {
    
    static let empty: Self = .init(
        creationDate: .init(),
        modificationDate: .init(),
        title: "",
        url: nil,
        note: "",
        tags: []
    )
}
