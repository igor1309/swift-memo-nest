//
//  ReducerSpy.swift
//  MemoNestTests
//
//  Created by Igor Malyarov on 21.07.2024.
//

final class ReducerSpy<State, Event, Effect> {
    
    private(set) var stubs: [(State, Effect?)]
    private(set) var messages = [Message]()
    
    init(
        stubs: [(State, Effect?)]
    ) {
        self.stubs = stubs
    }
    
    func reduce(
        _ state: State,
        _ event: Event
    ) -> (State, Effect?) {
        
        messages.append(.init(state: state, event: event))
        return stubs.removeFirst()
    }
    
    struct Message {
        
        let state: State
        let event: Event
    }
}

extension ReducerSpy.Message: Equatable where State: Equatable, Event: Equatable, Effect: Equatable {}
