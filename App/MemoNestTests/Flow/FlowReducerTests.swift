//
//  FlowReducerTests.swift
//  MemoNestTests
//
//  Created by Igor Malyarov on 21.07.2024.
//

import EntryEditorFeature
@testable import MemoNest
import XCTest

final class FlowReducerTests: XCTestCase {
    
    // MARK: - dismissModal
    
    func test_dismissModal_shouldResetModal() {
        
        let (sut, _) = makeSUT()

        let (state, _) = sut.reduce(.init(modal: .editor(makeEntry())), .dismissModal)
        
        XCTAssertNil(state.modal)
    }
    
    func test_dismissModal_shouldNotDeliverEffect() {
        
        let (sut, _) = makeSUT()

        let (_, effect) = sut.reduce(.init(modal: .editor(makeEntry())), .dismissModal)
        
        XCTAssertNil(effect)
    }
    
    // MARK: - editor event
    
    func test_editor_complete_shouldCallEditorReduceOnNilModal() {
        
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(), .editor(.complete))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.none])
        XCTAssertNoDiff(spy.messages.map(\.event), [.complete])
    }
    
    func test_editor_doneEditingWithNil_shouldCallEditorReduceOnNilModal() {
        
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(), .editor(.doneEditing(nil)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.none])
        XCTAssertNoDiff(spy.messages.map(\.event), [.doneEditing(nil)])
    }
    
    func test_editor_doneEditing_shouldCallEditorReduceOnNilModal() {
        
        let entry = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(), .editor(.doneEditing(entry)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.none])
        XCTAssertNoDiff(spy.messages.map(\.event), [.doneEditing(entry)])
    }
    
    func test_editor_editWithNil_shouldCallEditorReduceOnNilModal() {
        
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(), .editor(.edit(nil)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.none])
        XCTAssertNoDiff(spy.messages.map(\.event), [.edit(nil)])
    }
    
    func test_editor_edit_shouldCallEditorReduceOnNilModal() {
        
        let entry = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(), .editor(.edit(entry)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.none])
        XCTAssertNoDiff(spy.messages.map(\.event), [.edit(entry)])
    }
    
    func test_editor_complete_shouldCallEditorReduceOnNilEditorModal() {
        
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(modal: .editor(nil)), .editor(.complete))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(nil)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.complete])
    }
    
    func test_editor_doneEditingWithNil_shouldCallEditorReduceOnNilEditorModal() {
        
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(modal: .editor(nil)), .editor(.doneEditing(nil)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(nil)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.doneEditing(nil)])
    }
    
    func test_editor_doneEditing_shouldCallEditorReduceOnNilEditorModal() {
        
        let entry = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(modal: .editor(nil)), .editor(.doneEditing(entry)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(nil)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.doneEditing(entry)])
    }
    
    func test_editor_editWithNil_shouldCallEditorReduceOnNilEditorModal() {
        
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(modal: .editor(nil)), .editor(.edit(nil)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(nil)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.edit(nil)])
    }
    
    func test_editor_edit_shouldCallEditorReduceOnNilEditorModal() {
        
        let entry = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(modal: .editor(nil)), .editor(.edit(entry)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(nil)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.edit(entry)])
    }
    
    func test_editor_complete_shouldCallEditorReduceOnEditorModal() {
        
        let entry0 = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(modal: .editor(entry0)), .editor(.complete))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(entry0)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.complete])
    }
    
    func test_editor_doneEditingWithNil_shouldCallEditorReduceOnEditorModal() {
        
        let entry0 = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(modal: .editor(entry0)), .editor(.doneEditing(nil)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(entry0)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.doneEditing(nil)])
    }
    
    func test_editor_doneEditing_shouldCallEditorReduceOnEditorModal() {
        
        let entry0 = makeEntry()
        let entry = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(modal: .editor(entry0)), .editor(.doneEditing(entry)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(entry0)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.doneEditing(entry)])
    }
    
    func test_editor_editWithNil_shouldCallEditorReduceOnEditorModal() {
        
        let entry0 = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(modal: .editor(entry0)), .editor(.edit(nil)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(entry0)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.edit(nil)])
    }
    
    func test_editor_edit_shouldCallEditorReduceOnEditorModal() {
        
        let entry0 = makeEntry()
        let entry = makeEntry()
        let (sut, spy) = makeSUT()
        
        _ = sut.reduce(.init(modal: .editor(entry0)), .editor(.edit(entry)))
        
        XCTAssertNoDiff(spy.messages.map(\.state), [.editor(entry0)])
        XCTAssertNoDiff(spy.messages.map(\.event), [.edit(entry)])
    }
    
    func test_editor_shouldResetModalOnEditorReduceStateNone() {
        
        let (sut, _) = makeSUT(stubs: [(.none, nil)])
        
        let (state, _) = sut.reduce(.init(modal: .editor(nil)), .editor(.complete))
        
        XCTAssertNil(state.modal)
    }
    
    func test_editor_shouldSetModalTiEditorReduceStateEditorNil() {
        
        let (sut, _) = makeSUT(stubs: [(.editor(nil), nil)])
        
        let (state, _) = sut.reduce(.init(), .editor(.complete))
        
        XCTAssertNoDiff(state.modal, .editor(nil))
    }
    
    func test_editor_shouldSetModalTiEditorReduceStateEditor() {
        
        let entry = makeEntry()
        let (sut, _) = makeSUT(stubs: [(.editor(entry), nil)])
        
        let (state, _) = sut.reduce(.init(), .editor(.complete))
        
        XCTAssertNoDiff(state.modal, .editor(entry))
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
