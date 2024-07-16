//
//  ListFlowView.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

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
        
        factory.makeEntryListView { entry in
            
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
        case let .detail(entry):
            Text("TBD: Detail View for \(entry)")
                .toolbar {
                    
                    ToolbarItem {
                        
                        Button("Edit Entry", systemImage: "square.and.pencil") {
                            
                            print("TBD: edit entry", entry)
                        }
                    }
                }
        }
    }
    
    func modalContent(
        modal: ListFlowState.Modal
    ) -> some View {
        
        switch modal {
        case .editor:
            Text("TBD: Editor")
        }
    }
}

#Preview {
    
    NavigationView {
        
        ListFlowView(model: .preview(), factory: .preview())
    }
}
