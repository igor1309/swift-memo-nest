//
//  EntryListReducerTests.swift
//
//
//  Created by Igor Malyarov on 17.07.2024.
//

struct EntryListState<Entry, Sort> {
    
    var entries: [Entry]
    var sort: Sort
    var isLoading = false
}

extension EntryListState: Equatable where Entry: Equatable, Sort: Equatable {}

enum EntryListEvent<Entry, Sort> {
    
    case load
    case loaded([Entry])
    case setSort(Sort)
}

extension EntryListEvent: Equatable where Entry: Equatable, Sort: Equatable {}

enum EntryListEffect<Sort> {
    
    case load(Sort)
}

extension EntryListEffect: Equatable where Sort: Equatable {}

final class EntryListReducer<Entry, Sort>
where Sort: Equatable {}

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
            state.isLoading = false
            
        case let .setSort(sort):
            reduce(&state, &effect, with: sort)
        }
        
        return (state, effect)
    }
}

extension EntryListReducer {
    
    typealias State = EntryListState<Entry, Sort>
    typealias Event = EntryListEvent<Entry, Sort>
    typealias Effect = EntryListEffect<Sort>
}

private extension EntryListReducer {
    
    func load(
        _ state: inout State,
        _ effect: inout Effect?
    ) {
        guard !state.isLoading else { return }
        
        state.isLoading = true
        effect = .load(state.sort)
    }
    
    func reduce(
        _ state: inout State,
        _ effect: inout Effect?,
        with sort: Sort
    ) {
        guard sort != state.sort else { return }
        
        state.entries = []
        state.sort = sort
        state.isLoading = true
        effect = .load(sort)
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
        
        let sort = makeSort()
        let state = makeState(sort: sort)
        
        assert(.load, on: state, effect: .load(sort))
    }
    
    // MARK: - loaded
    
    func test_loaded_shouldSetEntriesToLoadedOnEmptyAndIsLoadingToFalse() {
        
        let state = makeState(entries: [], isLoading: true)
        let loaded = makeEntries()
        
        assertState(.loaded(loaded), on: state) {
            
            $0.entries = loaded
            $0.isLoading = false
        }
    }
    
    func test_loaded_shouldNotDeliverEffectOnEmpty() {
    
        let state = makeState(entries: [], isLoading: true)
        
        assert(.loaded(makeEntries()), on: state, effect: nil)
    }
    
    func test_loaded_shouldAppendEntriesToNonEmptyAndFlipIsLoadingToFalse() {
        
        let existing = makeEntries()
        let state = makeState(entries: existing, isLoading: true)
        let loaded = makeEntries()
        
        assertState(.loaded(loaded), on: state) {
            
            $0.entries = existing + loaded
            $0.isLoading = false
        }
    }
    
    func test_loaded_shouldNotDeliverEffectOnNonEmpty() {
        
        let state = makeState(entries: makeEntries(), isLoading: true)
        
        assert(.loaded(makeEntries()), on: state, effect: nil)
    }
    
    // MARK: - setSort
    
    func test_setSort_shouldNotChangeStateOnSameSort() {
        
        let sort = makeSort()
        
        assertState(.setSort(sort), on: makeState(sort: sort))
    }
    
    func test_setSort_shouldNotDeliverEffectOnSameSort() {
    
        let sort = makeSort()
        
        assert(.setSort(sort), on: makeState(sort: sort), effect: nil)
    }
    
    func test_setSort_shouldResetEntriesSetSortAndSetIsLoadingToTrue() {
        
        let (oldSort, sort) = (makeSort(), makeSort())
        let state = makeState(sort: oldSort)
        
        assertState(.setSort(sort), on: state) {
            
            XCTAssertFalse(state.entries.isEmpty)
            $0.entries = []
            $0.sort = sort
            $0.isLoading = true
        }
    }
    
    func test_setSort_shouldDeliverEffectWithSort() {
    
        let sort = makeSort()
        
        assert(.setSort(sort), on: makeState(), effect: .load(sort))
    }
    
    // MARK: - Helpers
    
    private typealias Entry = String
    private typealias Sort = String
    private typealias SUT = EntryListReducer<Entry, Sort>
    
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
    
    private func makeSort(
        _ value: String = UUID().uuidString
    ) -> Sort {
        
        return value
    }
    
    private func makeState(
        entries: [Entry]? = nil,
        sort: Sort? = nil,
        isLoading: Bool = false
    ) -> SUT.State {
        
        return .init(
            entries: entries ?? makeEntries(),
            sort: sort ?? makeSort(),
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
