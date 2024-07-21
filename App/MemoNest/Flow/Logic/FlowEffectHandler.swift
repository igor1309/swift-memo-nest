//
//  FlowEffectHandler.swift
//  MemoNest
//
//  Created by Igor Malyarov on 21.07.2024.
//
import EntryEditorFeature

final class FlowEffectHandler {
    
    let editorEffectHandle: EditorEffectHandle
    
    init(editorEffectHandle: @escaping EditorEffectHandle) {
        
        self.editorEffectHandle = editorEffectHandle
    }
    
    typealias EditorEvent = EditorFlowEvent<EntryEditorFeature.Entry>
    typealias EditorEffect = EditorFlowEffect<EntryEditorFeature.Entry>
    typealias EditorDispatch = (EditorEvent) -> Void
    typealias EditorEffectHandle = (EditorEffect, @escaping EditorDispatch) -> Void
}

extension FlowEffectHandler {
    
    func handleEffect(
        _ effect: Effect,
        _ dispatch: @escaping Dispatch
    ) {
        switch effect {
        case let .editor(editor):
            editorEffectHandle(editor) { dispatch(.editor($0)) }
        }
    }
}

extension FlowEffectHandler {
    
    typealias Dispatch = (Event) -> Void
    
    typealias Event = FlowEvent
    typealias Effect = FlowEffect
}
