//
//  ListFlowViewComposer.swift
//  MemoNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import CombineSchedulers
import EntryListFeature
import Foundation

final class ListFlowViewComposer {
    
    private let makeEntryListModel: MakeEntryListModel
    private let scheduler: AnySchedulerOf<DispatchQueue>
    
    init(
        makeEntryListModel: @escaping MakeEntryListModel,
        scheduler: AnySchedulerOf<DispatchQueue> = .main
    ) {
        self.makeEntryListModel = makeEntryListModel
        self.scheduler = scheduler
    }
    
    typealias MakeEntryListModel = () -> EntryListModel<Entry>
}

extension ListFlowViewComposer {
    
    func composeViewModel() -> ListFlowModel {
        
        let model = makeEntryListModel()
        let reducer = ListFlowReducer(
            isValid: {
                
                !$0.note.isEmpty || !$0.tags.isEmpty || !$0.title.isEmpty || $0.url != nil
            }
        )
        let effectHandler = ListFlowEffectHandler()
        
        return .init(
            initialState: .init(content: model),
            reduce: reducer.reduce(_:_:),
            handleEffect: effectHandler.handleEffect(_:_:),
            scheduler: scheduler
        )
    }
    
    func composeFactory() -> ListFlowViewFactory {
        
        return .init()
    }
}
