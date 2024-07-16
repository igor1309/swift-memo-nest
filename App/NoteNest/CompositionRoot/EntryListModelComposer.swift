//
//  EntryListModelComposer.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import CombineSchedulers
import EntryListFeature
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
    
    func compose() -> EntryListModel<Entry> {
        
        let reducer = EntryListReducer<Entry>()
        
        let composer = EntryListEffectHandlerMicroServicesComposer()
        let effectHandler = EntryListEffectHandler<Entry>(
            microServices: composer.compose()
        )
        
        return .init(
            initialState: .init(),
            reduce: reducer.reduce(_:_:),
            handleEffect: effectHandler.handleEffect(_:_:),
            scheduler: scheduler
        )
    }
}
