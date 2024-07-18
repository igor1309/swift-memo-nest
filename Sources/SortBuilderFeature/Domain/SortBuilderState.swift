//
//  SortBuilderState.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

import Foundation

struct SortBuilderState<T> {
    
    var selectedComparators: [KeyPathComparator<T>] = []
    var selectedKeyPath: String? = nil
    var sortOrder: SortOrder = .forward
    var showingAlert = false
    let keyPaths: [String: PartialKeyPath<T>]
}
