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
        
        Group {
            switch model.state {
            case .failure:
                loadFailureView()
                
            case let .success(entries):
                listView(entries: entries)
            }
        }
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

private extension EntryListView {
    
    func loadFailureView() -> some View {
     
        Text("Error loading entries.")
            .foregroundStyle(.red)
    }
    
    func listView(
        entries: [Entry]
    ) -> some View {
        
        List {
            
            ForEach(entries, content: entryView)
        }
        .listStyle(.plain)
    }
}
