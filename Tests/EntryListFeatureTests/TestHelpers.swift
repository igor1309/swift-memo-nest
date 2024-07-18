//
//  TestHelpers.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

import Foundation

struct Entry: Equatable {
    
    let value: String
}

struct Filter: Equatable {
    
    let value: String
}

struct Sort: Equatable {
    
    let value: String
}

typealias State = EntryListState<Entry, Filter, Sort>

func makeEntries(
    count: Int = .random(in: 1...100)
) -> [Entry] {
    
    (0..<count).map { _ in .init(value: UUID().uuidString) }
}

func makeFilter(
    _ value: String = UUID().uuidString
) -> Filter {
    
    return .init(value: value)
}

func makeSort(
    _ value: String = UUID().uuidString
) -> Sort {
    
    return .init(value: value)
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
