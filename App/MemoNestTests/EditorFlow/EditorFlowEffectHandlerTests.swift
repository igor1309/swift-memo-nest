//
//  EditorFlowEffectHandlerTests.swift
//  MemoNestTests
//
//  Created by Igor Malyarov on 21.07.2024.
//

@testable import MemoNest
import XCTest

final class EditorFlowEffectHandlerTests: XCTestCase {
    
    func test_init_shouldNotCallCollaborator() {
        
        let (sut, spy) = makeSUT()
        
        XCTAssertEqual(spy.callCount, 0)
        XCTAssertNotNil(sut)
    }
    
    func test_edited_shouldCallItemHandlerWitItem() {
        
        let item = makeItem()
        let (sut, spy) = makeSUT()
        
        sut.handleEffect(.edited(item)) { _ in }
        
        XCTAssertNoDiff(spy.payloads, [item])
    }
    
    func test_edited_shouldDeliverCompleteEventOnItemHandlerComplete() {
        
        let (sut, spy) = makeSUT()
        
        expect(sut, toDeliver: .complete, for: .edited(makeItem())) {
            
            spy.complete()
        }
    }
    
    // MARK: - Helpers
    
    private typealias Item = String
    private typealias SUT = EditorFlowEffectHandler<Item>
    private typealias ItemSpy = Spy<Item, Void, Never>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: SUT,
        spy: ItemSpy
    ) {
        let spy = ItemSpy()
        let sut = SUT(handleItem: spy.process(_:_:))
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(spy, file: file, line: line)
        
        return (sut, spy)
    }
    
    private func makeItem(
        _ value: String = UUID().uuidString
    ) -> Item {
        
        return value
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
