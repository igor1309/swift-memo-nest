//
//  EditorFlowEffectHandlerTests.swift
//  MemoNestTests
//
//  Created by Igor Malyarov on 21.07.2024.
//

/// A generic effect handler for editor flow, which processes items and dispatches events.
final class EditorFlowEffectHandler<Item> {
    
    /// The closure that handles items.
    private let handleItem: HandleItem
    
    /// Initialises the effect handler with a given item handler.
    ///
    /// - Parameter handleItem: The closure that processes items and calls a completion callback.
    init(handleItem: @escaping HandleItem) {
        
        self.handleItem = handleItem
    }
    
    /// A closure type alias for handling items with a completion callback.
    typealias HandleItem = (Item, @escaping () -> Void) -> Void
}

extension EditorFlowEffectHandler {
    
    /// Handles an effect by processing the associated item and dispatching an event upon completion.
    ///
    /// - Parameters:
    ///   - effect: The effect to handle.
    ///   - dispatch: The closure to dispatch events.
    func handleEffect(
        _ effect: Effect,
        _ dispatch: @escaping Dispatch
    ) {
        switch effect {
        case let .edited(item):
            handleItem(item) { dispatch(.complete) }
        }
    }
}

extension EditorFlowEffectHandler {
    
    /// A closure type alias for dispatching events.
    typealias Dispatch = (Event) -> Void
    
    /// Type alias for events related to the editor flow.
    typealias Event = EditorFlowEvent<Item>

    /// Type alias for effects related to the editor flow.
    typealias Effect = EditorFlowEffect<Item>
}

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
