//
//  LoaderDecoratorTests.swift
//  
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Tools
import XCTest

final class LoaderDecoratorTests: XCTestCase {
    
    func test_init_shouldNotCallCollaborators() {
        
        let (sut, decoratee, decorateSpy) = makeSUT()
        
        XCTAssertEqual(decoratee.callCount, 0)
        XCTAssertEqual(decorateSpy.callCount, 0)
        XCTAssertNotNil(sut)
    }

    // MARK: - Helpers
    
    private typealias SUT = LoaderDecorator<Payload, Success, Failure>
    private typealias Decoratee = Spy<Payload, Success, Failure>
    private typealias DecorateSpy = Spy<Result<Success, Failure>, Void, Never>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: SUT,
        decoratee: Decoratee,
        decorateSpy: DecorateSpy
    ) {
        let decoratee = Decoratee()
        let decorateSpy = DecorateSpy()
        let sut = SUT(
            decoratee: decoratee,
            decorate: { payload, completion in
                
                decorateSpy.process(payload) { _ in completion() }
            }
        )
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(decoratee, file: file, line: line)
        trackForMemoryLeaks(decorateSpy, file: file, line: line)
        
        return (sut, decoratee, decorateSpy)
    }
    
    private struct Payload: Equatable {
        
        let value: String
    }
    
    private struct Success: Equatable {
        
        let value: String
    }

    private struct Failure: Error, Equatable {
        
        let value: String
    }
}

extension Spy: Loader {
    
    func load(
        _ payload: Payload,
        _ completion: @escaping (Result<Success, Failure>) -> Void
    ) {
        process(payload, completion: completion)
    }
}
