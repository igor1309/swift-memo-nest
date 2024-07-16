//
//  EntryListView.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import SwiftUI

struct EntryListView<EntryView: View>: View {
    
    @StateObject private var model: EntryListModel
    
    private let entryView: (Entry) -> EntryView
    
    init(
        model: EntryListModel,
        entryView: @escaping (Entry) -> EntryView
    ) {
        self._model = .init(wrappedValue: model)
        self.entryView = entryView
    }
    
    var body: some View {
        
        List {
            
            ForEach(model.state, content: entryView)
        }
        .listStyle(.plain)
        .onFirstAppear { model.event(.load) }
    }
}

#Preview {
    
    NavigationView {
        
        EntryListView(model: .preview()) { entry in
        
            Button(entry.text) { print(entry) }
                .font(.subheadline)
        }
            .navigationTitle("Entries")
    }
}
