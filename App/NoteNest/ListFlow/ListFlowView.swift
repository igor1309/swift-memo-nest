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
    }
}

#Preview {
    ListFlowView(model: .init())
}
