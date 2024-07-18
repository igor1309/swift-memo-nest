//
//  SortBuilderEvent.swift
//  
//
//  Created by Igor Malyarov on 18.07.2024.
//

import Foundation

enum SortBuilderEvent {
    
    case addComparator
    case dismissAlert
    case deleteComparators(IndexSet)
    case updateSelectedKeyPath(String?)
    case updateSortOrder(SortOrder)
}
