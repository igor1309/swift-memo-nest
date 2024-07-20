//
//  CacheCoordinatorTests.swift
//
//
//  Created by Igor Malyarov on 20.07.2024.
//

final class CacheCoordinator {
    
}

import Cache
import XCTest

final class CacheCoordinatorTests: XCTestCase {
    
    // MARK: - Helpers
    
    private typealias SUT = CacheCoordinator
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT {
        
        let sut = SUT()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
}
