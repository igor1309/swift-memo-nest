//
//  EditorFlowReducerTests.swift
//  MemoNestTests
//
//  Created by Igor Malyarov on 21.07.2024.
//

enum EditorFlowState<Item> {
    
    case none
    case editor(Item?)
}

extension EditorFlowState: Equatable where Item: Equatable {}

enum EditorFlowEvent<Item> {
    
    case complete
    case doneEditing(Item?)
    case edit(Item?)
}

extension EditorFlowEvent: Equatable where Item: Equatable {}

enum EditorFlowEffect<Item> {
    
    case edited(Item)
}

extension EditorFlowEffect: Equatable where Item: Equatable {}

final class EditorFlowReducer<Item> {}

extension EditorFlowReducer {
    
    func reduce(
        _ state: State,
        _ event: Event
    ) -> (State, Effect?) {
        
        var state = state
        var effect: Effect?
        
        switch event {
        case .complete:
            guard case .editor = state else { break }
            
            state = .none
            
        case let .doneEditing(item):
            guard case .editor = state else { break }
            
            effect = item.map(Effect.edited)
            
        case let .edit(item):
            guard case .none = state else { break }
            
            state = .editor(item)
        }
        
        return (state, effect)
    }
}

extension EditorFlowReducer {
    
    typealias State = EditorFlowState<Item>
    typealias Event = EditorFlowEvent<Item>
    typealias Effect = EditorFlowEffect<Item>
}

import XCTest

final class EditorFlowReducerTests: XCTestCase {
    
    // MARK: - complete
    
    func test_complete_shouldNotChangeNoneState() {
        
        assert(.none, event: .complete)
    }
    
    func test_complete_shouldNotDeliverEffectOnNoneState() {
        
        assert(.none, event: .complete, delivers: nil)
    }
    
    func test_complete_shouldChangeNilEditorStateToNone() {
        
        assert(.editor(nil), event: .complete) {
            
            $0 = .none
        }
    }
    
    func test_complete_shouldNotDeliverEffectOnNilEditorState() {
        
        assert(.editor(nil), event: .complete, delivers: nil)
    }
    
    func test_complete_shouldChangeEditorStateToNone() {
        
        assert(.editor(makeItem()), event: .complete) {
            
            $0 = .none
        }
    }
    
    func test_complete_shouldNotDeliverEffectOnEditorState() {
        
        assert(.editor(makeItem()), event: .complete, delivers: nil)
    }
    
    // MARK: - doneEditing
    
    func test_doneEditingWithoutItem_shouldNotChangeNoneState() {
        
        assert(.none, event: .doneEditing(nil))
    }
    
    func test_doneEditingWithoutItem_shouldNotDeliverEffectOnNoneState() {
        
        assert(.none, event: .doneEditing(nil), delivers: nil)
    }
    
    func test_doneEditingWithItem_shouldNotChangeNoneState() {
        
        assert(.none, event: .doneEditing(makeItem()))
    }
    
    func test_doneEditingWithItem_shouldNotDeliverEffectOnNoneState() {
        
        assert(.none, event: .doneEditing(nil), delivers: nil)
    }
    
    func test_doneEditingWithoutItem_shouldNotChangeNilEditorState() {
        
        assert(.editor(nil), event: .doneEditing(nil))
    }
    
    func test_doneEditingWithoutItem_shouldNotDeliverEffectNilEditorState() {
        
        assert(.editor(nil), event: .doneEditing(nil), delivers: nil)
    }
    
    func test_doneEditingWithItem_shouldNotChangeNilEditorState() {
        
        assert(.editor(nil), event: .doneEditing(makeItem()))
    }
    
    func test_doneEditingWithItem_shouldDeliverEffectOnNilEditorState() {
        
        let item = makeItem()
        
        assert(.editor(nil), event: .doneEditing(item), delivers: .edited(item))
    }
    
    func test_doneEditingWithoutItem_shouldNotChangeEditorState() {
        
        assert(.editor(makeItem()), event: .doneEditing(nil))
    }
    
    func test_doneEditingWithoutItem_shouldNotDeliverEffectEditorState() {
        
        assert(.editor(makeItem()), event: .doneEditing(nil), delivers: nil)
    }
    
    func test_doneEditingWithItem_shouldNotChangeEditorState() {
        
        assert(.editor(makeItem()), event: .doneEditing(makeItem()))
    }
    
    func test_doneEditingWithItem_shouldDeliverEffectOnEditorState() {
        
        let item = makeItem()
        
        assert(.editor(makeItem()), event: .doneEditing(item), delivers: .edited(item))
    }
    
    // MARK: - edit
    
    func test_editWithoutItem_shouldChangeNoneStateToEditingWithoutItem() {
        
        assert(.none, event: .edit(nil)) {
            
            $0 = .editor(nil)
        }
    }
    
    func test_editWithoutItem_shouldNotDeliverEffectOnNoneState() {
        
        assert(.none, event: .edit(nil), delivers: nil)
    }
    
    func test_editWithItem_shouldChangeNoneStateToEditingWithItem() {
        
        let item = makeItem()
        
        assert(.none, event: .edit(item)) {
            
            $0 = .editor(item)
        }
    }
    
    func test_editWithItem_shouldNotDeliverEffectOnNoneState() {
        
        assert(.none, event: .edit(makeItem()), delivers: nil)
    }
    
    func test_editWithoutItem_shouldNotChangeEditorState() {
        
        assert(.editor(nil), event: .edit(makeItem()))
    }
    
    func test_editWithoutItem_shouldNotDeliverEffectOnEditorState() {
        
        assert(.editor(nil), event: .edit(makeItem()), delivers: nil)
    }
    
    func test_editWithItem_shouldNotChangeEditorState() {
        
        assert(.editor(makeItem()), event: .edit(makeItem()))
    }
    
    func test_editWithItem_shouldNotDeliverEffectOnEditorState() {
        
        assert(.editor(makeItem()), event: .edit(makeItem()), delivers: nil)
    }
    
    // MARK: - Helpers
    
    private typealias Item = String
    private typealias SUT = EditorFlowReducer<Item>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT {
        
        let sut = SUT()
        
        trackForMemoryLeaks(sut, file: file, line: line)
        
        return sut
    }
    
    private func makeItem(
        _ value: String = UUID().uuidString
    ) -> Item {
        
        return value
    }
    
    @discardableResult
    private func assert(
        sut: SUT? = nil,
        _ state: SUT.State,
        event: SUT.Event,
        updateStateToExpected: ((inout SUT.State) -> Void)? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT.State {
        
        let sut = sut ?? makeSUT(file: file, line: line)
        
        var expectedState = state
        updateStateToExpected?(&expectedState)
        
        let (receivedState, _) = sut.reduce(state, event)
        
        XCTAssertEqual(
            receivedState,
            expectedState,
            "\nExpected \(String(describing: expectedState)), but got \(String(describing: receivedState)) instead.",
            file: file, line: line
        )
        
        return receivedState
    }
    
    @discardableResult
    private func assert(
        sut: SUT? = nil,
        _ state: SUT.State,
        event: SUT.Event,
        delivers expectedEffect: SUT.Effect?,
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT.Effect? {
        
        let sut = sut ?? makeSUT(file: file, line: line)
        
        let (_, receivedEffect) = sut.reduce(state, event)
        
        XCTAssertEqual(
            receivedEffect,
            expectedEffect,
            "\nExpected \(String(describing: expectedEffect)), but got \(String(describing: receivedEffect)) instead.",
            file: file, line: line
        )
        
        return receivedEffect
    }
}
