//
//  EntryListView.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

#if canImport(SwiftUI)
import SwiftUI

struct EntryListView<Entry: Identifiable, EntryView: View>: View {
    
    let state: State
    let event: (Event) -> Void
    let entryView: (Entry) -> EntryView
    
    var body: some View {
        
        Group {
            switch state.result {
            case .none:
                progressView()
                
            case .failure:
                switch state.status {
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
        .onFirstAppear { event(.load) }
    }
}

extension EntryListView {
    
    typealias State = EntryListState<Entry>
    typealias Event = EntryListEvent<Entry>
}

private extension EntryListView {
    
    func progressView() -> some View {
        
        ProgressView().id(UUID())
    }
    
    func loadFailureView() -> some View {
        
        VStack(spacing: 32) {
            
            Text("Error loading entries.")
                .foregroundColor(.red)
            
            Button("Reload", action: { event(.load) })
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
            
            if state.status == .inflight {
                
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
                    event(.loadMore(after: entry.id))
                }
            }
    }
}

// MARK: - Previews

private func entryListView(
    initialState: EntryListState<PreviewEntry> = .init()
) -> some View {
    
    NavigationView {
        
        EntryListView(
            state: initialState,
            event: { print($0) }
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
