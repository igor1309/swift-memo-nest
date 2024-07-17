//
//  EntryListReducerTests.swift
//
//
//  Created by Igor Malyarov on 17.07.2024.
//

struct EntryListState<Entry> {
    
    var entries: [Entry]
    var isLoading = false
}

extension EntryListState: Equatable where Entry: Equatable {}

enum EntryListEvent<Entry> {
    
    case load
    case loaded([Entry])
}

extension EntryListEvent: Equatable where Entry: Equatable {}

enum EntryListEffect: Equatable {
    
    case load
}

final class EntryListReducer<Entry> {}

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
            
        case let .loaded(newEntries):
            state.entries += newEntries
        }
        
        return (state, effect)
    }
}

extension EntryListReducer {
    
    typealias State = EntryListState<Entry>
    typealias Event = EntryListEvent<Entry>
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
    
    // MARK: - loaded
    
    func test_loaded_shouldSetEntriesToLoadedOnEmpty() {
        
        let loaded = makeEntries()
        
        assertState(.loaded(loaded), on: makeState(entries: [])) {
            
            $0.entries = loaded
        }
    }
    
    func test_loaded_shouldNotDeliverEffectOnEmpty() {
        
        assert(.loaded(makeEntries()), on: makeState(entries: []), effect: nil)
    }
    
    func test_loaded_shouldAppendEntriesToNonEmpty() {
        
        let existing = makeEntries()
        let loaded = makeEntries()
        
        assertState(.loaded(loaded), on: makeState(entries: existing)) {
            
            $0.entries = existing + loaded
        }
    }
    
    func test_loaded_shouldNotDeliverEffectOnNonEmpty() {
        
        assert(.loaded(makeEntries()), on: makeState(entries: makeEntries()), effect: nil)
    }
    
    // MARK: - Helpers
    
    private typealias Entry = String
    private typealias SUT = EntryListReducer<Entry>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT {
        
        let sut = SUT()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func makeEntries(
        count: Int = .random(in: 1...100)
    ) -> [Entry] {
        
        (0..<count).map { _ in UUID().uuidString }
    }
    
    private func makeState(
        entries: [Entry]? = nil,
        isLoading: Bool = false
    ) -> SUT.State {
        
        return .init(
            entries: entries ?? makeEntries(),
            isLoading: isLoading
        )
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
