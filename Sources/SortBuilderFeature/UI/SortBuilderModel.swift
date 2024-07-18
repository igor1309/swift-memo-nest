//
//  SortBuilderModel.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

import Foundation

final class SortBuilderModel<T>: ObservableObject {
    
    @Published private(set) var state: SortBuilderState<T>
    
    private let reduce: (inout SortBuilderState<T>, SortBuilderEvent) -> Void
    
    init(
        keyPaths: [String: PartialKeyPath<T>],
        reduce: @escaping (inout SortBuilderState<T>, SortBuilderEvent) -> Void
    ) {
        self.reduce = reduce
        self.state = .init(selectedKeyPath: keyPaths.keys.first, keyPaths: keyPaths)
    }
    
    func event(_ event: SortBuilderEvent) {
        
        reduce(&state, event)
    }
}
