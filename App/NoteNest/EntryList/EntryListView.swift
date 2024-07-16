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
            switch model.state.result {
            case .none:
                progressView()
                
            case .failure:
                switch model.state.status {
                case .none:
                    loadFailureView()
                    
                case .inflight:
                    progressView()
                }
                
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
    
    func progressView() -> some View {
        
        ProgressView().id(UUID())
    }
    
    func loadFailureView() -> some View {
        
        VStack(spacing: 32) {
            
            Text("Error loading entries.")
                .foregroundStyle(.red)
            
            Button("Reload", action: { model.event(.load) })
                .buttonStyle(.borderedProminent)
        }
    }
    
    func listView(
        entries: [Entry]
    ) -> some View {
        
        List {
            
            ForEach(entries) {
                
                entryView(entry: $0, lastID: entries.last?.id)
            }
            
            if model.state.status == .inflight {
                
                progressView()
            }
        }
        .scrollDismissesKeyboard(.immediately)
        .scrollContentBackground(.hidden)
        .listStyle(.plain)
    }
    
    private func entryView(
        entry: Entry,
        lastID id: Entry.ID?
    ) -> some View {
        
        entryView(entry)
            .onFirstAppear {
                
                if entry.id == id {
                    model.event(.loadMore(after: entry.id))
                }
            }
    }
}
