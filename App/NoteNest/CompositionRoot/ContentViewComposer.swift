//
//  ContentViewComposer.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import CombineSchedulers
import EntryListFeature
import Foundation

final class ContentViewComposer {
    
    private let makeEntryListModel: MakeEntryListModel
    private let scheduler: AnySchedulerOf<DispatchQueue>
    
    init(
        makeEntryListModel: @escaping MakeEntryListModel,
        scheduler: AnySchedulerOf<DispatchQueue> = .main
    ) {
        self.makeEntryListModel = makeEntryListModel
        self.scheduler = scheduler
    }
    
    typealias MakeEntryListModel = () -> EntryListModel
}

extension ContentViewComposer {
    
    func composeViewModel(
        initialState: ListFlowState = .init()
    ) -> ListFlowModel {
        
        let reducer = ListFlowReducer()
        let effectHandler = ListFlowEffectHandler()
        
        return .init(
            initialState: initialState,
            reduce: reducer.reduce(_:_:),
            handleEffect: effectHandler.handleEffect(_:_:),
            scheduler: scheduler
        )
    }
    
    func composeFactory() -> ListFlowFactory {
        
        return .init(model: makeEntryListModel())
    }
}
