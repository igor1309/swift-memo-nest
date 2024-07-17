//
//  ListFlowView.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import EntryEditorFeature
import EntryListFeature
import SwiftUI
import UIPrimitives

struct ListFlowView: View {
    
    @StateObject private var model: ListFlowModel
    
    private let factory: ListFlowFactory
    
    init(
        model: ListFlowModel,
        factory: ListFlowFactory
    ) {
        self._model = .init(wrappedValue: model)
        self.factory = factory
    }
    
    var body: some View {
        
        factory.makeEntryListView(model: model.state.content) { entry in
            
            entryRow(entry, event: { model.event(.select(entry)) })
        }
        .navigationDestination(
            destination: model.state.destination,
            dismissDestination: { model.event(.dismiss(.destination)) },
            content: destinationContent
        )
        .sheet(
            modal: model.state.modal,
            dismissModal: { model.event(.dismiss(.modal)) },
            content: modalContent
        )
        .toolbar {
            
            ToolbarItem {
                
                Button("Add Entry", systemImage: "plus") {
                    
                    model.event(.addEntry)
                }
            }
        }
    }
}

extension ListFlowState.Destination: Identifiable {
    
    var id: ID {
        
        switch self {
        case .detail: return .detail
        }
    }
    
    enum ID: Hashable {
        
        case detail
    }
}

extension ListFlowState.Modal: Identifiable {
    
    var id: ID {
        
        switch self {
        case .editor: return .editor
        }
    }
    
    enum ID: Hashable {
        
        case editor
    }
}

private extension ListFlowView {
    
    private func entryRow(
        _ entry: Entry,
        event: @escaping () -> Void
    ) -> some View {
        
        Button(entry.text, action: event)
            .font(.subheadline)
    }
    
    func destinationContent(
        destination: ListFlowState.Destination
    ) -> some View {
        
        switch destination {
        case let .detail(detail):
            EntryDetailView(entry: detail.entry)
                .navigationBarTitleDisplayMode(.inline)
                .sheet(
                    modal: detail.modal,
                    dismissModal: { model.event(.dismiss(.destinationModal)) },
                    content: modalContent
                )
                .toolbar {
                    
                    ToolbarItem {
                        
                        Button("Edit Entry", systemImage: "square.and.pencil") {
                            
                            model.event(.edit(detail.entry))
                        }
                    }
                }
        }
    }
    
    @ViewBuilder
    func modalContent(
        modal: ListFlowState.Modal
    ) -> some View {
        
        switch modal {
        case .editor:
#warning("pass non empty for editing")
            EntryEditorWrapperView(
                onCancel: { model.event(.dismiss(.modal)) },
                onSave: { model.event(.save($0)) }
            )
        }
    }
    
    @ViewBuilder
    func modalContent(
        modal: ListFlowState.Destination.Detail.Modal
    ) -> some View {
        
        switch modal {
        case let .editor(entry):
            EntryEditorWrapperView(
                entry: entry,
                onCancel: { model.event(.dismiss(.destinationModal)) },
                onSave: { model.event(.save($0)) }
            )
        }
    }
}

extension ListFlowState.Destination.Detail.Modal: Identifiable {
    
    var id: ID {
        
        switch self {
        case let .editor(entry):
            return .editor(entry.id)
        }
    }
    
    enum ID: Hashable {
        
        case editor(Entry.ID)
    }
}

// MARK: - Previews

#Preview {
    
    NavigationStack {
        
        ListFlowView(model: .preview(), factory: .preview())
    }
}
