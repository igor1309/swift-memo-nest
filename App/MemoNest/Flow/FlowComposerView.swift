//
//  FlowComposerView.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

import EntryEditorFeature
import SwiftUI
import IMRx

struct FlowComposerView: View {
    
    private let model: FlowModel
    
    init(destination: FlowState.Destination? = nil) {
        
        typealias Entry = EntryEditorFeature.Entry
        
        let editorFlowReducer = EditorFlowReducer<Entry>()
        let reducer = FlowReducer(
            editorReduce: editorFlowReducer.reduce(_:_:)
        )
        
        let editorFlowEffectHandler = EditorFlowEffectHandler<Entry>(
            handleItem: { entry, completion in
                
                dump(entry)
                completion()
            }
        )
        let effectHandler = FlowEffectHandler(
            editorEffectHandle: editorFlowEffectHandler.handleEffect(_:_:)
        )
        
        self.model = .init(
            initialState: .init(destination: destination),
            reduce: reducer.reduce(_:_:),
            handleEffect: effectHandler.handleEffect(_:_:)
        )
    }
    
    var body: some View {
        
        NavigationStack {
            
            FlowStateWrapperView(model: model)
        }
    }
}

#Preview {
    FlowComposerView()
}
