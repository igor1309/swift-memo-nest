//
//  EntryListModelComposer.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import CombineSchedulers
import Foundation

final class EntryListModelComposer {
    
    private let scheduler: AnySchedulerOf<DispatchQueue>
    
    init(
        scheduler: AnySchedulerOf<DispatchQueue> = .main
    ) {
        self.scheduler = scheduler
    }
}

extension EntryListModelComposer {
    
    func compose() -> EntryListModel {
        
        let reducer = EntryListReducer()
        let effectHandler = EntryListEffectHandler()
        
        return .init(
            initialState: [],
            reduce: reducer.reduce(_:_:),
            handleEffect: effectHandler.handleEffect(_:_:),
            scheduler: scheduler
        )
    }
}
