//
//  EntryFilterBuilderReducer.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

import EntryFilterFeature
import XCTest

class EntryFilterBuilderReducerTests: XCTestCase {
    
    func test_setSearchText_updatesSearchText() {
        
        let searchText = "Swift"
        
        assert(makeState(), event: .setSearchText(searchText)) {
            
            $0.searchText = searchText
        }
    }
    
    func test_setTags_updatesTags() {
        
        let tags = "swift,programming"
        
        assert(makeState(), event: .setTags(tags)) {
            
            $0.tags = tags
        }
    }
    
    func test_setStartDate_updatesStartDate() {
        
        let startDate = Date().addingTimeInterval(-86_400)
        
        assert(makeState(), event: .setStartDate(startDate)) {
            
            $0.startDate = startDate
        }
    }
    
    func test_setEndDate_updatesEndDate() {
        
        let endDate = Date().addingTimeInterval(86400)
        
        assert(makeState(), event: .setEndDate(endDate)) {
            
            $0.endDate = endDate
        }
    }
    
    func test_setCombination_updatesCombination() {
        
        assert(makeState(combination: .and), event: .setCombination(.or)) {
            
            $0.combination = .or
        }
    }
    
    func test_filter_computedProperty() {
        
        let initialState = makeState(
            searchText: "Swift",
            tags: "programming,swift",
            startDate: Date().addingTimeInterval(-86_400),
            endDate: Date().addingTimeInterval(86_400),
            combination: .and
        )
        
        XCTAssertNoDiff(initialState.filter, .init(
            searchText: "Swift",
            tags: ["programming", "swift"],
            dateRange: .init(
                start: initialState.startDate,
                end: initialState.endDate
            ),
            combination: .and
        ))
    }
    
    // MARK: - Helpers
    
    typealias SUT = EntryFilterBuilderReducer
    typealias State = SUT.State
    typealias Event = SUT.Event
    
    func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT {
        
        let sut = SUT()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func makeState(
        searchText: String = "",
        tags: String = "",
        startDate: Date = .init().addingTimeInterval(-7 * 86400),
        endDate: Date = .init(),
        combination: FilterCombination = .and
    ) -> State {
        
        return .init(searchText: searchText, tags: tags, startDate: startDate, endDate: endDate, combination: combination)
    }
    
    @discardableResult
    private func assert(
        sut: SUT? = nil,
        _ state: State,
        event: Event,
        updateStateToExpected: ((inout State) -> Void)? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> State {
        
        let sut = sut ?? makeSUT(file: file, line: line)
        
        var expectedState = state
        updateStateToExpected?(&expectedState)
        
        var receivedState = state
        sut.reduce(state: &receivedState, event: event)
        
        XCTAssertEqual(
            receivedState,
            expectedState,
            "\nExpected \(expectedState), but got \(receivedState) instead.",
            file: file, line: line
        )
        
        return receivedState
    }
}
