//
//  EntryLoaderIntegrationTests.swift
//  MemoNestTests
//
//  Created by Igor Malyarov on 19.07.2024.
//

import CacheInfra
import Tools

final class EntryLoader {}

import MemoNest
import XCTest

final class EntryLoaderIntegrationTests: XCTestCase {

    // MARK: - Helpers
    
    private typealias SUT = EntryLoader
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT {
        
        let sut = SUT()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
}
