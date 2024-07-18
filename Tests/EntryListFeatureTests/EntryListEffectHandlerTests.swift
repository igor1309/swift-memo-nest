//
//  EntryListEffectHandlerTests.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

final class EntryListEffectHandler<Entry, Filter, Sort> {}

extension EntryListEffectHandler {
    
    func handleEffect(
        _ effect: Effect,
        _ dispatch: @escaping Dispatch
    ) {
        switch effect {
        case let .load(filter, sort):
            break
        }
    }
}

extension EntryListEffectHandler {
    
    typealias Dispatch = (Event) -> Void
    
    typealias Event = EntryListEvent<Entry, Filter, Sort>
    typealias Effect = EntryListEffect<Filter, Sort>
}

import XCTest

final class EntryListEffectHandlerTests: XCTestCase {
    
    // MARK: - Helpers
    
    private typealias SUT = EntryListEffectHandler<Entry, Filter, Sort>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT {
        
        let sut = SUT()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func expect(
        _ sut: SUT,
        toDeliver expectedEvent: SUT.Event,
        for effect: SUT.Effect,
        on action: @escaping () -> Void,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "wait for completion")
        
        sut.handleEffect(effect) {
            
            XCTAssertNoDiff(expectedEvent, $0, "Expected \(expectedEvent), but got \($0) instead.", file: file, line: line)
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: 1)
    }
}
