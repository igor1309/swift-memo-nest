//
//  EntryFilterBuilderState.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

import Foundation


struct EntryFilterBuilderState {
    
    var searchText: String = ""
    var tags: String = ""
    var startDate: Date = Date().addingTimeInterval(-7 * 86400)
    var endDate: Date = Date()
    var combination: FilterCombination = .and
}

extension EntryFilterBuilderState {
    
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
