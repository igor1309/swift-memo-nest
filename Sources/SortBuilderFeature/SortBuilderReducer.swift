//
//  SortBuilderReducer.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

import SwiftUI

final class SortBuilderReducer<T> {}

extension SortBuilderReducer {
    
    func reduce(
        state: inout SortBuilderState<T>,
        event: SortBuilderEvent
    ) {
        switch event {
        case .addComparator:
            addComparator(state: &state)
            
        case let .deleteComparators(offsets):
            state.selectedComparators.remove(atOffsets: offsets)
            
        case let .updateSelectedKeyPath(newValue):
            state.selectedKeyPath = newValue
            
        case let .updateSortOrder(newValue):
            state.sortOrder = newValue
        }
    }
}

private extension SortBuilderReducer {
    
    private func addComparator(state: inout SortBuilderState<T>) {
        
        if let key = state.selectedKeyPath, let keyPath = state.keyPaths[key] {
            if state.selectedComparators.contains(where: { $0.keyPath == keyPath }) {
                state.showingAlert = true
            } else {
                if let keyPath = keyPath as? KeyPath<T, String> {
                    state.selectedComparators.append(.init(keyPath, order: state.sortOrder))
                } else if let keyPath = keyPath as? KeyPath<T, Int> {
                    state.selectedComparators.append(.init(keyPath, order: state.sortOrder))
                }
                // Add more types as needed
            }
        }
    }
}
