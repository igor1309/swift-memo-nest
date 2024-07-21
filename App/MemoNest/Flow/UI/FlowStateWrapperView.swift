//
//  FlowStateWrapperView.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

import SwiftUI

struct FlowStateWrapperView: View {
    
    @StateObject private var model: Model
    
    init(model: Model) {
        
        self._model = .init(wrappedValue: model)
    }
    
    var body: some View {
        
        HStack {
            
            Button("add") { model.event(.editor(.edit(nil))) }
            Button("edit") { model.event(.editor(.edit(.init()))) }
        }
    }
}

extension FlowStateWrapperView {
    
    typealias Model = FlowModel
}
