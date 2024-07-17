//
//  EntryListReducerTests.swift
//
//
//  Created by Igor Malyarov on 17.07.2024.
//

struct EntryListState: Equatable {
    
    var isLoading = false
}

enum EntryListEvent: Equatable {
    
    case load
}

enum EntryListEffect: Equatable {
    
    case load
}

final class EntryListReducer {}

extension EntryListReducer {
    
    func reduce(
        _ state: State,
        _ event: Event
    ) -> (State, Effect?) {
        
        var state = state
        var effect: Effect?
        
        switch event {
        case .load:
            load(&state, &effect)
        }
        
        return (state, effect)
    }
}

extension EntryListReducer {
    
    typealias State = EntryListState
    typealias Event = EntryListEvent
    typealias Effect = EntryListEffect
}

private extension EntryListReducer {
    
    func load(
        _ state: inout State,
        _ effect: inout Effect?
    ) {
        guard !state.isLoading else { return }

        state.isLoading = true
        effect = .load
    }
}

import XCTest

final class EntryListReducerTests: XCTestCase {
    
    // MARK: - load
    
    func test_load_shouldNotChangeStateOnIsLoading() {
        
        assertState(.load, on: makeState(isLoading: true))
    }
    
    func test_load_shouldNotDeliverEffectOnIsLoading() {
        
        assert(.load, on: makeState(isLoading: true), effect: nil)
    }
    
    func test_load_shouldSetIsLoadingToTrue() {
        
        assertState(.load, on: makeState()) {
            
            $0.isLoading = true
        }
    }
    
    func test_load_shouldDeliverEffect() {
        
        assert(.load, on: makeState(), effect: .load)
    }
    
    // MARK: - Helpers
    
    private typealias SUT = EntryListReducer
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT {
        
        let sut = SUT()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func makeState(
        isLoading: Bool = false
    ) -> SUT.State {
        
        return .init(isLoading: isLoading)
    }
    
    private typealias UpdateStateToExpected<State> = (_ state: inout State) -> Void
    
    private func assertState(
        sut: SUT? = nil,
        _ event: SUT.Event,
        on state: SUT.State,
        updateStateToExpected: UpdateStateToExpected<SUT.State>? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let sut = sut ?? makeSUT(file: file, line: line)
        
        var expectedState = state
        updateStateToExpected?(&expectedState)
        
        let (receivedState, _) = sut.reduce(state, event)
        
        XCTAssertNoDiff(
            receivedState,
            expectedState,
            "\nExpected \(expectedState), but got \(receivedState) instead.",
            file: file, line: line
        )
    }
    
    private func assert(
        sut: SUT? = nil,
        _ event: SUT.Event,
        on state: SUT.State,
        effect expectedEffect: SUT.Effect?,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let sut = sut ?? makeSUT(file: file, line: line)
        let (_, receivedEffect) = sut.reduce(state, event)
        
        XCTAssertNoDiff(
            receivedEffect,
            expectedEffect,
            "\nExpected \(String(describing: expectedEffect)), but got \(String(describing: receivedEffect)) instead.",
            file: file, line: line
        )
    }
}
