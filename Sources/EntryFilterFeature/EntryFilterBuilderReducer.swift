//
//  EntryFilterBuilderReducer.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

public final class EntryFilterBuilderReducer {
    
    public init() {}
}

public extension EntryFilterBuilderReducer {
    
    typealias State = EntryFilterBuilderState
    typealias Event = EntryFilterBuilderEvent
    
    func reduce(
        state: inout State,
        event: Event
    ) {
        switch event {
        case let .setSearchText(text):
            state.searchText = text
            
        case let .setTags(tags):
            state.tags = tags
            
        case let .setStartDate(date):
            state.startDate = date
            
        case let .setEndDate(date):
            state.endDate = date
            
        case let .setCombination(combination):
            state.combination = combination
        }
    }
}
