//
//  TestHelpers.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

import Foundation

typealias Entry = String
typealias Filter = String
typealias Sort = String
typealias State = EntryListState<Entry, Filter, Sort>

func makeEntries(
    count: Int = .random(in: 1...100)
) -> [Entry] {
    
    (0..<count).map { _ in UUID().uuidString }
}

func makeFilter(
    _ value: String = UUID().uuidString
) -> Filter {
    
    return value
}

func makeSort(
    _ value: String = UUID().uuidString
) -> Sort {
    
    return value
}

func makeState(
    entries: [Entry]? = nil,
    filter: Filter? = nil,
    sort: Sort? = nil,
    isLoading: Bool = false
) -> State {
    
    return .init(
        entries: entries ?? makeEntries(),
        filter: filter ?? makeFilter(),
        sort: sort ?? makeSort(),
        isLoading: isLoading
    )
}
