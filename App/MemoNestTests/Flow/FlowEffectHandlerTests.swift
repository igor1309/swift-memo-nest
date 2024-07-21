//
//  FlowEffectHandlerTests.swift
//  MemoNestTests
//
//  Created by Igor Malyarov on 21.07.2024.
//

import EntryEditorFeature
@testable import MemoNest
import XCTest

final class FlowEffectHandlerTests: XCTestCase {
    
    func test_init_shouldNotCallCollaborator() {
        
        let (sut, spy) = makeSUT()
        
        XCTAssertEqual(spy.callCount, 0)
        XCTAssertNotNil(sut)
    }
    
    func test_editor_shouldCallEditorEffectHandle() {
        
        let entry = makeEntry()
        let (sut, spy) = makeSUT()
        
        sut.handleEffect(.editor(.edited(entry))) { _ in }
        
        XCTAssertNoDiff(spy.payloads, [.edited(entry)])
    }
    
    func test_editor_shouldDispatchEditorEffectHandlerEvent() {
        
        let entry = makeEntry()
        let event: FlowEvent.EditorEvent = .doneEditing(entry)
        let (sut, spy) = makeSUT()
        
        expect(sut, toDeliver: .editor(event), for: .editor(.edited(makeEntry()))) {
            
            spy.complete(with: .success(event))
        }
    }
    
    // MARK: - Helpers
    
    private typealias SUT = FlowEffectHandler
    private typealias EditorSpy = Spy<SUT.EditorEffect, SUT.EditorEvent, Never>
    private typealias Entry = EntryEditorFeature.Entry
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: SUT,
        spy: EditorSpy
    ) {
        let spy = EditorSpy()
        let sut = SUT(editorEffectHandle: spy.process)
        
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
