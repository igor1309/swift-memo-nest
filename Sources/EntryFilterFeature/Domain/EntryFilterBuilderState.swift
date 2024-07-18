//
//  EntryFilterBuilderState.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

import Foundation


public struct EntryFilterBuilderState {
    
    public var searchText: String
    public var tags: String
    public var startDate: Date
    public var endDate: Date
    public var combination: FilterCombination
    
    public init(
        searchText: String = "",
        tags: String = "",
        startDate: Date = .init().addingTimeInterval(-7 * 86400),
        endDate: Date = .init(),
        combination: FilterCombination = .and
    ) {
        self.searchText = searchText
        self.tags = tags
        self.startDate = startDate
        self.endDate = endDate
        self.combination = combination
    }
}

public extension EntryFilterBuilderState {
    
    var filter: EntryFilter {
        
        let tagList = tags
            .split(separator: ",")
            .map { $0.trimmingCharacters(in: .whitespaces) }
        
        let dateRange = DateInterval(start: startDate, end: endDate)
        
        return .init(
            searchText: searchText,
            tags: tagList,
            dateRange: dateRange,
            combination: combination
        )
    }
}
