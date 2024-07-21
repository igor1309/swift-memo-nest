//
//  FlowReducerTest.swift
//  MemoNestTests
//
//  Created by Igor Malyarov on 21.07.2024.
//

import EntryEditorFeature
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
