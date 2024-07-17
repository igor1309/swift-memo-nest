//
//  ListFlowModel+preview.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

extension ListFlowModel {
    
    static func preview(
        initialState: ListFlowState = .init(content: .preview())
    ) -> Self {
        
        let reducer = ListFlowReducer(isValid: { _ in true })
        let effectHandler = ListFlowEffectHandler()
        
        return .init(
            initialState: initialState,
            reduce: reducer.reduce(_:_:),
            handleEffect: effectHandler.handleEffect(_:_:)
        )
    }
}
