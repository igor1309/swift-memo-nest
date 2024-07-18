//
//  EntryFilter.swift
//  
//
//  Created by Igor Malyarov on 18.07.2024.
//

import Foundation

struct EntryFilter: Equatable {
    
    let searchText: String?
    let tags: [String]?
    let dateRange: DateInterval?
    let combination: FilterCombination

    init(
        searchText: String? = nil,
        tags: [String]? = nil,
        dateRange: DateInterval? = nil,
        combination: FilterCombination = .and
    ) {
        self.searchText = searchText
        self.tags = tags
        self.dateRange = dateRange
        self.combination = combination
    }
}
