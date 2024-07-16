//
//  EntryListView.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

#if canImport(SwiftUI)
import SwiftUI
import UIPrimitives

public struct EntryListView<EntryView: View>: View {
    
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
                if entries.isEmpty {
                    Text("No entries")
                } else {
                    listView(entries: entries)
                }
            }
        }
        .onFirstAppear { model.event(.load) }
    }
}

private extension EntryListView {
    
    func progressView() -> some View {
        
        ProgressView().id(UUID())
    }
    
    func loadFailureView() -> some View {
        
        VStack(spacing: 32) {
            
            Text("Error loading entries.")
                .foregroundColor(.red)
            
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

// MARK: - Previews

private func entryListView(
    initialState: EntryListState = .init()
) -> some View {
    
    NavigationView {
        
        EntryListView(
            model: .preview(initialState: initialState)
        ) { entry in
            
            Button(entry.text) { print(entry) }
                .font(.subheadline)
        }
        .navigationTitle("Entries")
    }
}

struct EntryListView_Previews: PreviewProvider {
    
    static var previews: some View {
        
        Group {
            
            entryListView()
            entryListView(initialState: .init(result: .failure(.init())))
            entryListView(initialState: .init(result: .success([])))
            entryListView(initialState: .init(result: .success(.preview())))
            entryListView(initialState: .init(
                result: .success(.preview()),
                status: .inflight
            ))
        }
    }
}
#endif
