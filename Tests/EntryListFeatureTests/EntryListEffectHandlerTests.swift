//
//  EntryListEffectHandlerTests.swift
//
//
//  Created by Igor Malyarov on 18.07.2024.
//

final class EntryListEffectHandler<Entry, Filter, Sort> {
    
    private let load: Load
    
    init(load: @escaping Load) {
        
        self.load = load
    }
}

extension EntryListEffectHandler {
    
    typealias LoadPayload = (Filter, Sort)
    typealias LoadResult = Result<[Entry], Error>
    typealias LoadCompletion = (LoadResult) -> Void
    typealias Load = (LoadPayload, @escaping LoadCompletion) -> Void
}

extension EntryListEffectHandler {
    
    func handleEffect(
        _ effect: Effect,
        _ dispatch: @escaping Dispatch
    ) {
        switch effect {
        case let .load(filter, sort):
            load(filter, sort, dispatch)
        }
    }
}

extension EntryListEffectHandler {
    
    typealias Dispatch = (Event) -> Void
    
    typealias Event = EntryListEvent<Entry, Filter, Sort>
    typealias Effect = EntryListEffect<Filter, Sort>
}

private extension EntryListEffectHandler {
    
    func load(
        _ filter: Filter,
        _ sort: Sort,
        _ dispatch: @escaping Dispatch
    ) {
        load((filter, sort)) {
            
            switch $0 {
            case .failure:
                dispatch(.loaded(.failure(.init())))
                
            case let .success(entries):
                dispatch(.loaded(.success(entries)))
            }
        }
    }
}

import XCTest

final class EntryListEffectHandlerTests: XCTestCase {
    
    // MARK: - init
    
    func test_init_shouldNotCallCollaborators() {
        
        let (_, loadSpy) = makeSUT()
        
        XCTAssertEqual(loadSpy.callCount, 0)
    }
    
    // MARK: - load
    
    func test_load_shouldCallLoadWithFilterAndSort() {
        
        let (filter, sort) = (makeFilter(), makeSort())
        let (sut, loadSpy) = makeSUT()
        
        sut.handleEffect(.load(filter, sort)) { _ in }
        
        XCTAssertNoDiff(loadSpy.payloads.map(\.0), [filter])
        XCTAssertNoDiff(loadSpy.payloads.map(\.1), [sort])
    }
    
    func test_load_shouldDeliverFailureOnLoadFailure() {
        
        let (filter, sort) = (makeFilter(), makeSort())
        let (sut, loadSpy) = makeSUT()
        
        expect(sut, toDeliver: .loaded(.failure(.init())), for: .load(filter, sort)) {
            
            loadSpy.complete(with: .failure(anyError()))
        }
    }
    
    func test_load_shouldDeliverEntriesOnLoadSuccess() {
        
        let (filter, sort) = (makeFilter(), makeSort())
        let entries = makeEntries()
        let (sut, loadSpy) = makeSUT()
        
        expect(sut, toDeliver: .loaded(.success(entries)), for: .load(filter, sort)) {
            
            loadSpy.complete(with: .success(entries))
        }
    }
    
    // MARK: - Helpers
    
    private typealias SUT = EntryListEffectHandler<Entry, Filter, Sort>
    private typealias LoadSpy = Spy<(Filter, Sort), [Entry], Error>
    
    private func makeSUT(
        file: StaticString = #file,
        line: UInt = #line
    ) -> (
        sut: SUT,
        loadSpy: LoadSpy
    ) {
        let loadSpy = LoadSpy()
        let sut = SUT(
            load: loadSpy.process
        )
        
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(loadSpy, file: file, line: line)
        
        return (sut, loadSpy)
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
