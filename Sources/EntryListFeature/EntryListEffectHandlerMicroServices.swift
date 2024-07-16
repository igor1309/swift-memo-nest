//
//  EntryListEffectHandlerMicroServices.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Foundation

public struct EntryListEffectHandlerMicroServices {
    
    public let load: Load
    public let loadMoreAfter: LoadMoreAfter
    
    public init(
        load: @escaping Load, 
        loadMoreAfter: @escaping LoadMoreAfter
    ) {
        self.load = load
        self.loadMoreAfter = loadMoreAfter
    }
}

public extension EntryListEffectHandlerMicroServices {
    
    typealias LoadResult = Event.LoadResult
    typealias LoadCompletion = (LoadResult) -> Void
    typealias Load = (@escaping LoadCompletion) -> Void
    
    typealias LoadMoreAfter = (Entry.ID, @escaping LoadCompletion) -> Void
    
    typealias Event = EntryListEvent
}
