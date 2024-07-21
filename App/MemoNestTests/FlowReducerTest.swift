//
//  FlowReducerTest.swift
//  MemoNestTests
//
//  Created by Igor Malyarov on 21.07.2024.
//

import EntryEditorFeature

/// Represents the state of the flow, including the current destination.
struct FlowState: Equatable {
    
    var destination: Destination? = nil
}

extension FlowState {
    
    /// Represents possible destinations within the flow.
    enum Destination: Equatable {
        
        case editor(EntryEditorFeature.Entry?)
    }
}

/// Represents events that can occur within the flow.
enum FlowEvent: Equatable {
    
    case editor(EditorEvent)
    
    /// Type alias for events specific to the editor flow.
    typealias EditorEvent = EditorFlowEvent<EntryEditorFeature.Entry>
}

/// Represents effects that can occur as a result of events within the flow.
enum FlowEffect: Equatable {
    
    case editor(EditorEffect)
    
    /// Type alias for effects specific to the editor flow.
    typealias EditorEffect = EditorFlowEffect<EntryEditorFeature.Entry>
}

/// Responsible for reducing events to state changes and producing effects.
final class FlowReducer {
    
    private let editorReduce: EditorReduce
    
    /// Initialises the reducer with a specific editor reducer function.
    /// - Parameter editorReduce: A function that reduces editor states and events to new states and optional effects.
    init(editorReduce: @escaping EditorReduce) {
        
        self.editorReduce = editorReduce
    }
    
    /// Type alias for the state of the editor flow.
    typealias EditorState = EditorFlowState<EntryEditorFeature.Entry>
    
    /// Type alias for the editor reducer function.
    typealias EditorReduce = (EditorState, Event.EditorEvent) -> (EditorState, Effect.EditorEffect?)
}

extension FlowReducer {
    
    /// Reduces a given state and event to a new state and an optional effect.
    /// - Parameters:
    ///   - state: The current state of the flow.
    ///   - event: The event to reduce.
    /// - Returns: A tuple containing the new state and an optional effect.
    func reduce(
        _ state: State,
        _ event: Event
    ) -> (State, Effect?) {
        
        var state = state
        var effect: Effect?
        
        switch event {
        case let .editor(event):
            reduce(&state, &effect, with: event)
        }
        
        return (state, effect)
    }
}

private extension FlowReducer {
    
    func reduce(
        _ state: inout State,
        _ effect: inout Effect?,
        with event: Event.EditorEvent
    ) {
        let (editorFlowState, editorFlowEffect) = editorReduce(state.editorFlowState, event)
        
        switch editorFlowState {
        case .none:
            state.destination = .none
            
        case let .editor(entry):
            state.destination = .editor(entry)
        }
        
        effect = editorFlowEffect.map(Effect.editor)
    }
}

private extension FlowState {
    
    var editorFlowState: EditorFlowState<EntryEditorFeature.Entry> {
        
        switch destination {
        case let .editor(entry):
            return .editor(entry)
            
        default:
            return .none
        }
    }
}

extension FlowReducer {
    
    typealias State = FlowState
    typealias Event = FlowEvent
    typealias Effect = FlowEffect
}

@testable import MemoNest
import XCTest

final class FlowReducerTest: XCTestCase {
    
    // MARK: - editor event
    
    func test_editor_complete_shouldCallEditorReduceOnNilDestination() {
        
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(), .editor(.complete))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.none])
        XCTAssertNoDiff(spy.messages.map(\.event), [.complete])
    }
    
    func test_editor_doneEditingWithNil_shouldCallEditorReduceOnNilDestination() {
        
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(), .editor(.doneEditing(nil)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.none])
        XCTAssertNoDiff(spy.messages.map(\.event), [.doneEditing(nil)])
    }
    
    func test_editor_doneEditing_shouldCallEditorReduceOnNilDestination() {
        
        let entry = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(), .editor(.doneEditing(entry)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.none])
        XCTAssertNoDiff(spy.messages.map(\.event), [.doneEditing(entry)])
    }
    
    func test_editor_editWithNil_shouldCallEditorReduceOnNilDestination() {
        
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(), .editor(.edit(nil)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.none])
        XCTAssertNoDiff(spy.messages.map(\.event), [.edit(nil)])
    }
    
    func test_editor_edit_shouldCallEditorReduceOnNilDestination() {
        
        let entry = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(), .editor(.edit(entry)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.none])
        XCTAssertNoDiff(spy.messages.map(\.event), [.edit(entry)])
    }
    
    func test_editor_complete_shouldCallEditorReduceOnNilEditorDestination() {
        
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(destination: .editor(nil)), .editor(.complete))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(nil)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.complete])
    }
    
    func test_editor_doneEditingWithNil_shouldCallEditorReduceOnNilEditorDestination() {
        
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(destination: .editor(nil)), .editor(.doneEditing(nil)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(nil)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.doneEditing(nil)])
    }
    
    func test_editor_doneEditing_shouldCallEditorReduceOnNilEditorDestination() {
        
        let entry = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(destination: .editor(nil)), .editor(.doneEditing(entry)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(nil)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.doneEditing(entry)])
    }
    
    func test_editor_editWithNil_shouldCallEditorReduceOnNilEditorDestination() {
        
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(destination: .editor(nil)), .editor(.edit(nil)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(nil)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.edit(nil)])
    }
    
    func test_editor_edit_shouldCallEditorReduceOnNilEditorDestination() {
        
        let entry = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(destination: .editor(nil)), .editor(.edit(entry)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(nil)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.edit(entry)])
    }
    
    func test_editor_complete_shouldCallEditorReduceOnEditorDestination() {
        
        let entry0 = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(destination: .editor(entry0)), .editor(.complete))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(entry0)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.complete])
    }
    
    func test_editor_doneEditingWithNil_shouldCallEditorReduceOnEditorDestination() {
        
        let entry0 = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(destination: .editor(entry0)), .editor(.doneEditing(nil)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(entry0)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.doneEditing(nil)])
    }
    
    func test_editor_doneEditing_shouldCallEditorReduceOnEditorDestination() {
        
        let entry0 = makeEntry()
        let entry = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(destination: .editor(entry0)), .editor(.doneEditing(entry)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(entry0)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.doneEditing(entry)])
    }
    
    func test_editor_editWithNil_shouldCallEditorReduceOnEditorDestination() {
        
        let entry0 = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(destination: .editor(entry0)), .editor(.edit(nil)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(entry0)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.edit(nil)])
    }
    
    func test_editor_edit_shouldCallEditorReduceOnEditorDestination() {
        
        let entry0 = makeEntry()
        let entry = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(destination: .editor(entry0)), .editor(.edit(entry)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(entry0)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.edit(entry)])
    }
    
    func test_editor_shouldResetDestinationOnEditorReduceStateNone() {
        
        let (sut, _) = makeSUT(stubs: [(.none, nil)])
        
        let (state, _) = sut.reduce(.init(destination: .editor(nil)), .editor(.complete))
        
        XCTAssertNil(state.destination)
    }
    
    func test_editor_shouldSetDestinationTiEditorReduceStateEditorNil() {
        
        let (sut, _) = makeSUT(stubs: [(.editor(nil), nil)])
        
        let (state, _) = sut.reduce(.init(), .editor(.complete))
        
        XCTAssertNoDiff(state.destination, .editor(nil))
    }
    
    func test_editor_shouldSetDestinationTiEditorReduceStateEditor() {
        
        let entry = makeEntry()
        let (sut, _) = makeSUT(stubs: [(.editor(entry), nil)])
        
        let (state, _) = sut.reduce(.init(), .editor(.complete))
        
        XCTAssertNoDiff(state.destination, .editor(entry))
    }
    
    func test_editor_shouldSetEffectToEditorReduceEffect() {
        
        let entry = makeEntry()
        let (sut, _) = makeSUT(stubs: [(.none, .edited(entry))])
        
        let (_, effect) = sut.reduce(.init(), .editor(.complete))
        
        XCTAssertNoDiff(effect, .editor(.edited(entry)))
    }
    
    func test_editor_shouldSetEffectToEditorReduceNilEffect() {
        
        let (sut, _) = makeSUT(stubs: [(.none, nil)])
        
        let (_, effect) = sut.reduce(.init(), .editor(.complete))
        
        XCTAssertNoDiff(effect, nil)
    }
    
    // MARK: - Helpers
    
    private typealias Entry = EntryEditorFeature.Entry
    private typealias SUT = FlowReducer
    private typealias Spy = ReducerSpy<EditorFlowState<Entry>, EditorFlowEvent<Entry>, EditorFlowEffect<Entry>>
    
    private func makeSUT(
        stubs: [(EditorFlowState<Entry>, EditorFlowEffect<Entry>?)] = [(.none, nil)],
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: SUT,
        spy: Spy
    ) {
        let spy = Spy(stubs: stubs)
        let sut = SUT(editorReduce: spy.reduce(_:_:))
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(spy, file: file, line: line)
        
        return (sut, spy)
    }
    
    private func makeEntry(
        title: String = anyMessage(),
        url: URL? = .init(string: "any-url"),
        note: String = anyMessage(),
        tags: [String] = [anyMessage()]
    ) -> Entry {
        
        return .init(title: title, url: url, note: note, tags: tags)
    }
}
