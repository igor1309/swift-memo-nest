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
        
        let composer = EntryListEffectHandlerMicroServicesComposer()
        let effectHandler = EntryListEffectHandler(
            microServices: composer.compose()
        )
        
        return .init(
            initialState: .success([]),
            reduce: reducer.reduce(_:_:),
            handleEffect: effectHandler.handleEffect(_:_:),
            scheduler: scheduler
        )
    }
}
