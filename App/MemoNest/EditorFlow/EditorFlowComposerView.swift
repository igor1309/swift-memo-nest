//
//  EditorFlowComposerView.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//

import EntryEditorFeature
import SwiftUI

struct EditorFlowComposerView: View {
    
    typealias Entry = EntryEditorFeature.Entry
    
    private let model: EditorFlowModel
    
    // composer
    init(
        initialState: EditorFlowState<Entry> = .none
    ) {
        let reducer = EditorFlowReducer<Entry>()
        let effectHandler = EditorFlowEffectHandler<Entry>(
            handleItem: { entry, completion in
                
                dump(entry)
                completion()
            }
        )
        
        self.model = .init(
            initialState: initialState,
            reduce: reducer.reduce(_:_:),
            handleEffect: effectHandler.handleEffect(_:_:)
        )
    }
    
    var body: some View {
        
        NavigationStack {
            
            EditorFlowStateWrapperView(model: model)
        }
    }
}

#Preview {
    EditorFlowComposerView()
}
