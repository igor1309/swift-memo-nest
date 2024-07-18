//
//  EntryFilterBuilderEvent.swift
//  
//
//  Created by Igor Malyarov on 18.07.2024.
//

import Foundation

public enum EntryFilterBuilderEvent: Equatable {
    
    case setSearchText(String)
    case setTags(String)
    case setStartDate(Date)
    case setEndDate(Date)
    case setCombination(FilterCombination)
}
