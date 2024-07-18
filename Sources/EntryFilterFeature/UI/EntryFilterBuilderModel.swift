//
//  EntryFilterBuilderModel.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

import Foundation

#warning("replace with RxViewModel")
final class EntryFilterBuilderModel: ObservableObject {
    
    @Published private(set) var state: EntryFilterBuilderState
    
    private let reduce: Reduce
    
    init(
        initialState: EntryFilterBuilderState = EntryFilterBuilderState(),
        reduce: @escaping Reduce
    ) {
        self.state = initialState
        self.reduce = reduce
    }
    
    typealias Reduce = (inout State, Event) -> Void
    typealias State = EntryFilterBuilderState
    typealias Event = EntryFilterBuilderEvent
}

extension EntryFilterBuilderModel {
    
    func event(_ event: EntryFilterBuilderEvent) {

        reduce(&state, event)
    }
}
