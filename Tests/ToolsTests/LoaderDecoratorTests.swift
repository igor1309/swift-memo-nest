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
    
    func test_load_shouldCallDecorateeWithPayload() {
        
        let payload = anyPayload()
        let (sut, decoratee, _) = makeSUT()
        
        sut.load(payload) { _ in }
        
        XCTAssertNoDiff(decoratee.payloads, [payload])
    }
    
    func test_load_shouldCallDecorateWithDecorateeFailure() {
        
        let payload = anyPayload()
        let result: SUT.LoadResult = .failure(anyFailure())
        let (sut, decoratee, decorateSpy) = makeSUT()
        
        sut.load(payload) { _ in }
        decoratee.complete(with: result)
        
        XCTAssertNoDiff(decorateSpy.payloads.map(\.0), [payload])
        XCTAssertNoDiff(decorateSpy.payloads.map(\.1), [result])
    }
    
    func test_load_shouldCallDecorateWithDecorateeSuccess() {
        
        let payload = anyPayload()
        let result: SUT.LoadResult = .success(anySuccess())
        let (sut, decoratee, decorateSpy) = makeSUT()
        
        sut.load(payload) { _ in }
        decoratee.complete(with: result)
        
        XCTAssertNoDiff(decorateSpy.payloads.map(\.0), [payload])
        XCTAssertNoDiff(decorateSpy.payloads.map(\.1), [result])
    }
    
    func test_load_shouldDeliverDecorateeFailure() {
        
        let result: SUT.LoadResult = .failure(anyFailure())
        let (sut, decoratee, decorateSpy) = makeSUT()
        
        assert(sut, with: anyPayload(), toDeliver: result) {
            
            decoratee.complete(with: result)
            decorateSpy.complete(with: .success(()))
        }
    }
    
    func test_load_shouldDeliverDecorateeSuccess() {
        
        let result: SUT.LoadResult = .success(anySuccess())
        let (sut, decoratee, decorateSpy) = makeSUT()
        
        assert(sut, with: anyPayload(), toDeliver: result) {
            
            decoratee.complete(with: result)
            decorateSpy.complete(with: .success(()))
        }
    }
    
    func test_load_shouldNotCallDecorateOnInstanceDeallocation() {
        
        var sut: SUT?
        let decoratee: Decoratee
        let decorateSpy: DecorateSpy
        (sut, decoratee, decorateSpy) = makeSUT()
        
        sut?.load(anyPayload()) { _ in }
        sut = nil
        decoratee.complete(with: .failure(anyFailure()))
        
        XCTAssertEqual(decorateSpy.callCount, 0)
    }
    
    func test_load_shouldNotDeliverDecorateeResultOnInstanceDeallocation() {
        
        var sut: SUT?
        let decoratee: Decoratee
        (sut, decoratee, _) = makeSUT()
        var result: SUT.LoadResult?
        
        sut?.load(anyPayload()) { result = $0 }
        sut = nil
        decoratee.complete(with: .failure(anyFailure()))
        
        XCTAssertNil(result)
    }
    
    // MARK: - Helpers
    
    private typealias SUT = LoaderDecorator<Payload, Success, Failure>
    private typealias Decoratee = Spy<Payload, Success, Failure>
    private typealias DecorateSpy = Spy<(Payload, Result<Success, Failure>), Void, Never>
    
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
            decorate: { payload, result, completion in
                
                decorateSpy.process((payload, result)) { _ in completion() }
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
    
    private func anyPayload(
        _ value: String = UUID().uuidString
    ) -> Payload {
        
        return .init(value: value)
    }
    
    private func anySuccess(
        _ value: String = UUID().uuidString
    ) -> Success {
        
        return .init(value: value)
    }
    
    private func anyFailure(
        _ value: String = UUID().uuidString
    ) -> Failure {
        
        return .init(value: value)
    }
    
    private func assert(
        _ sut: SUT,
        with payload: Payload,
        toDeliver expectedResult: Result<Success, Failure>,
        on action: @escaping () -> Void,
        timeout: TimeInterval = 0.05,
        file: StaticString = #file,
        line: UInt = #line
    ) {
        let exp = expectation(description: "wait for completion")
        
        sut.load(payload) {
            
            XCTAssertNoDiff($0, expectedResult, file: file, line: line)
            exp.fulfill()
        }
        
        action()
        
        wait(for: [exp], timeout: timeout)
    }
}
