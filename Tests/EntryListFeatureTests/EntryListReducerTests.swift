//
//  EntryListReducerTests.swift
//
//
//  Created by Igor Malyarov on 17.07.2024.
//

struct EntryListState<Entry, Filter, Sort> {
    
    var entries: [Entry]
    var filter: Filter
    var sort: Sort
    var isLoading = false
}

extension EntryListState: Equatable where Entry: Equatable, Filter: Equatable, Sort: Equatable {}

enum EntryListEvent<Entry, Filter, Sort> {
    
    case load
    case loaded(LoadResult)
    case setFilter(Filter)
    case setSort(Sort)
}

extension EntryListEvent {
    
    struct LoadFailure: Error, Equatable {}
    typealias LoadResult = Result<[Entry], LoadFailure>
}

extension EntryListEvent: Equatable where Entry: Equatable, Filter: Equatable, Sort: Equatable {}

enum EntryListEffect<Entry, Filter, Sort> {
    
    case load(LoadPayload)
}

extension EntryListEffect {
    
    struct LoadPayload {
        
        let lastEntry: Entry?
        let filter: Filter
        let sort: Sort
        
        init(
            lastEntry: Entry? = nil,
            filter: Filter,
            sort: Sort
        ) {
            self.lastEntry = lastEntry
            self.filter = filter
            self.sort = sort
        }
    }
}

extension EntryListEffect.LoadPayload: Equatable where Entry: Equatable, Filter: Equatable, Sort: Equatable {}
extension EntryListEffect: Equatable where Entry: Equatable, Filter: Equatable, Sort: Equatable {}

final class EntryListReducer<Entry, Filter, Sort>
where Filter: Equatable,
      Sort: Equatable {}

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
            
        case let .loaded(result):
            state.entries += (try? result.get()) ?? []
            state.isLoading = false
            
        case let .setFilter(filter):
            reduce(&state, &effect, with: filter)
            
        case let .setSort(sort):
            reduce(&state, &effect, with: sort)
        }
        
        return (state, effect)
    }
}

extension EntryListReducer {
    
    typealias State = EntryListState<Entry, Filter, Sort>
    typealias Event = EntryListEvent<Entry, Filter, Sort>
    typealias Effect = EntryListEffect<Entry, Filter, Sort>
}

private extension EntryListReducer {
    
    func load(
        _ state: inout State,
        _ effect: inout Effect?
    ) {
        guard !state.isLoading else { return }
        
        state.isLoading = true
        effect = .load(.init(
            lastEntry: state.entries.last, 
            filter: state.filter,
            sort: state.sort
        ))
    }
    
    func reduce(
        _ state: inout State,
        _ effect: inout Effect?,
        with filter: Filter
    ) {
        guard filter != state.filter else { return }
        
        state.entries = []
        state.filter = filter
        state.isLoading = true
        effect = .load(.init(filter: filter, sort: state.sort))
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
        effect = .load(.init(filter: state.filter, sort: sort))
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
    
    func test_load_shouldSetIsLoadingToTrueOnEmptyEntries() {
        
        assertState(.load, on: makeState(entries: [])) {
            
            $0.isLoading = true
        }
    }
    
    func test_load_shouldDeliverEffectWithNilLastEntryOnEmptyEntries() {
        
        let state = makeState(entries: [])
        
        assert(.load, on: state, effect: .load(.init(lastEntry: nil, filter: state.filter, sort: state.sort)))
    }
    
    func test_load_shouldSetIsLoadingToTrueOnNonEmpty() {
        
        assertState(.load, on: makeState()) {
            
            $0.isLoading = true
        }
    }
    
    func test_load_shouldDeliverEffectWithLastEntryOnNonEmpty() {
        
        let entries =  makeEntries(count: 5)
        let last = makeEntry()
        let state = makeState(entries: entries + [last])
        
        assert(.load, on: state, effect: .load(.init(lastEntry: last, filter: state.filter, sort: state.sort)))
    }
    
    // MARK: - loaded
    
    func test_loaded_shouldNotChangeEntriesAndSetIsLoadingToFalseOnLoadFailure() {
        
        let state = makeState(entries: [], isLoading: true)
        
        assertState(.loaded(.failure(.init())), on: state) {
            
            $0.isLoading = false
        }
    }
    
    func test_loaded_shouldNotDeliverEffectOnEmptyStateOnLoadFailure() {
    
        let state = makeState(entries: [], isLoading: true)
        
        assert(.loaded(.failure(.init())), on: state, effect: nil)
    }
    
    func test_loaded_shouldSetEntriesToLoadedOnEmptyAndIsLoadingToFalseOnLoadSuccess() {
        
        let state = makeState(entries: [], isLoading: true)
        let loaded = makeEntries()
        
        assertState(.loaded(.success(loaded)), on: state) {
            
            $0.entries = loaded
            $0.isLoading = false
        }
    }
    
    func test_loaded_shouldNotDeliverEffectOnEmptyStateOnLoadSuccess() {
    
        let state = makeState(entries: [], isLoading: true)
        
        assert(.loaded(.success(makeEntries())), on: state, effect: nil)
    }
    
    func test_loaded_shouldNotChangeNonEmptyAndSetFlipIsLoadingToFalseOnLoadFailure() {
        
        let existing = makeEntries()
        let state = makeState(entries: existing, isLoading: true)
        
        assertState(.loaded(.failure(.init())), on: state) {
            
            $0.isLoading = false
        }
    }
    
    func test_loaded_shouldNotDeliverEffectOnNonEmptyOnLoadFailure() {
        
        let state = makeState(entries: makeEntries(), isLoading: true)
        
        assert(.loaded(.failure(.init())), on: state, effect: nil)
    }
    
    func test_loaded_shouldAppendEntriesToNonEmptyAndFlipIsLoadingToFalseOnLoadSuccess() {
        
        let existing = makeEntries()
        let state = makeState(entries: existing, isLoading: true)
        let loaded = makeEntries()
        
        assertState(.loaded(.success(loaded)), on: state) {
            
            $0.entries = existing + loaded
            $0.isLoading = false
        }
    }
    
    func test_loaded_shouldNotDeliverEffectOnNonEmptyOnLoadSuccess() {
        
        let state = makeState(entries: makeEntries(), isLoading: true)
        
        assert(.loaded(.success(makeEntries())), on: state, effect: nil)
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
        let state = makeState()
        
        assert(.setSort(sort), on: state, effect: .load(.init(filter: state.filter, sort: sort)))
    }
    
    // MARK: - setFilter
    
    func test_setFilter_shouldNotChangeStateOnSameFilter() {
        
        let filter = makeFilter()
        
        assertState(.setFilter(filter), on: makeState(filter: filter))
    }
    
    func test_setFilter_shouldNotDeliverEffectOnSameFilter() {
    
        let filter = makeFilter()
        
        assert(.setFilter(filter), on: makeState(filter: filter), effect: nil)
    }
    
    func test_setFilter_shouldResetEntriesSetFilterAndSetIsLoadingToTrue() {
        
        let (oldFilter, filter) = (makeFilter(), makeFilter())
        let state = makeState(filter: oldFilter)
        
        assertState(.setFilter(filter), on: state) {
            
            XCTAssertFalse(state.entries.isEmpty)
            $0.entries = []
            $0.filter = filter
            $0.isLoading = true
        }
    }
    
    func test_setFilter_shouldDeliverEffectWithFilter() {
    
        let filter = makeFilter()
        let state = makeState()
        
        assert(.setFilter(filter), on: state, effect: .load(.init(filter: filter, sort: state.sort)))
    }
    
    // MARK: - Helpers
    
    private typealias SUT = EntryListReducer<Entry, Filter, Sort>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT {
        
        let sut = SUT()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
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
