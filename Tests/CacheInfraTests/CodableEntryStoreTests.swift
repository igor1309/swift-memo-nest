//
//  CodableEntryStoreTests.swift
//
//
//  Created by Igor Malyarov on 19.07.2024.
//

final class CodableEntryStore {
    
}

import XCTest

final class CodableEntryStoreTests: XCTestCase {
    
    func test_init() {
        
        _ = makeSUT()
    }

    // MARK: - Helpers
    
    private typealias SUT = CodableEntryStore
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT {
        
        let sut = SUT()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
}
