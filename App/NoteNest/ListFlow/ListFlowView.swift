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
    
    init(model: ListFlowModel) {
        
        self._model = .init(wrappedValue: model)
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .navigationDestination(
                destination: model.state.destination,
                dismissDestination: { model.event(.dismiss(.destination)) },
                content: destinationContent
            )
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

private extension ListFlowView {
    
    func destinationContent(
        destination: ListFlowState.Destination
    ) -> some View {
        
        switch destination {
        case .detail:
            Text("TBD: Detail View")
        }
    }
}

#Preview {
    ListFlowView(model: .preview())
}
