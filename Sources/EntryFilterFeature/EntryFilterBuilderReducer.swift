//
//  EntryFilterBuilderReducer.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

final class EntryFilterBuilderReducer {}

extension EntryFilterBuilderReducer {
    
    func reduce(
        state: inout EntryFilterBuilderState,
        event: EntryFilterBuilderEvent
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
