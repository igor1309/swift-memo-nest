//
//  EntryListEffectHandlerMicroServices.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Foundation

struct EntryListEffectHandlerMicroServices {
    
    let load: Load
    let loadMoreAfter: LoadMoreAfter
}

extension EntryListEffectHandlerMicroServices {
    
    typealias LoadResult = Event.LoadResult
    typealias LoadCompletion = (LoadResult) -> Void
    typealias Load = (@escaping LoadCompletion) -> Void
    
    typealias LoadMoreAfter = (Entry.ID, @escaping LoadCompletion) -> Void
    
    typealias Event = EntryListEvent
}
