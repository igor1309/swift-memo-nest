//
//  EntryFilter.swift
//  
//
//  Created by Igor Malyarov on 18.07.2024.
//

import Foundation

public struct EntryFilter: Equatable {
    
    public let searchText: String?
    public let tags: [String]?
    public let dateRange: DateInterval?
    public let combination: FilterCombination

    public init(
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
