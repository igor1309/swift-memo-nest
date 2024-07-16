//
//  EntryListEffectHandler.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Foundation

public final class EntryListEffectHandler {
    
    private let microServices: MicroServices
    
    public init(microServices: MicroServices) {
        
        self.microServices = microServices
    }
    
    public typealias MicroServices = EntryListEffectHandlerMicroServices
}

public extension EntryListEffectHandler {
    
    func handleEffect(
        _ effect: Effect,
        _ dispatch: @escaping Dispatch
    ) {
        switch effect {
        case .load:
            load(dispatch)
            
        case let .loadMore(after: id):
            loadMore(after: id, dispatch)
        }
    }
}

public extension EntryListEffectHandler {
    
    typealias Dispatch = (Event) -> Void
    
    typealias Event = EntryListEvent
    typealias Effect = EntryListEffect
}

private extension EntryListEffectHandler {
    
    func load(
        _ dispatch: @escaping Dispatch
    ) {
        microServices.load { dispatch(.loaded($0)) }
    }
    
    func loadMore(
        after id: Entry.ID,
        _ dispatch: @escaping Dispatch
    ) {
        microServices.loadMoreAfter(id) { dispatch(.loaded($0)) }
    }
}
