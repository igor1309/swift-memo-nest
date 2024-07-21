//
//  FlowStateWrapperView.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

import EntryEditorFeature
import SwiftUI
import UIPrimitives

struct FlowStateWrapperView: View {
    
    @StateObject private var model: Model
    
    init(model: Model) {
        
        self._model = .init(wrappedValue: model)
    }
    
    var body: some View {
        
        HStack {
            
            Button("add") { model.event(.editor(.edit(nil))) }
            Button("edit") { model.event(.editor(.edit(.stub))) }
        }
        .navigationDestination(
            destination: model.state.destination,
            dismissDestination: { model.event(.dismissDestination) },
            content: destinationContent
        )
    }
}

extension EntryEditorFeature.Entry {
    
    static let stub: Self = .init(title: UUID().uuidString)
}

extension FlowState.Destination: Identifiable {
    
    var id: ID {
        
        switch self {
        case .editor: return .editor
        }
    }
    
    enum ID: Hashable {
        
        case editor
    }
}

extension FlowStateWrapperView {
    
    typealias Model = FlowModel
}

private extension FlowStateWrapperView {
    
    func destinationContent(
        destination: FlowState.Destination
    ) -> some View {
        
        switch destination {
        case let .editor(entry):
            EditorFlowStateWrapperView(
                entry: entry,
                event: { model.event(.editor(.doneEditing($0))) }
            )
        }
    }
}
