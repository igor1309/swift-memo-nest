//
//  EntryLoaderIntegrationTests.swift
//  MemoNestTests
//
//  Created by Igor Malyarov on 19.07.2024.
//

import CacheInfra
import Tools

final class EntryLoaderComposer {
    
    private let storeURL: URL
    
    init(storeURL: URL) {
     
        self.storeURL = storeURL
    }
}

 extension EntryLoaderComposer {
     
     func compose() -> any Loader {
        
         AnyLoader<Any, Any, Error> { _,_ in fatalError() }
     }
 }

import MemoNest
import XCTest

final class EntryLoaderComposerTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        setupEmptyStoreState()
    }
    
    override func tearDown() {
        super.tearDown()
        undoStoreSideEffects()
    }
    
    func test_init() {
        
        _ = makeSUT()
    }
    
    // MARK: - Helpers
    
    private typealias Composer = EntryLoaderComposer
    private typealias SUT = any Loader
    
    private func makeSUT(
        storeURL: URL? = nil,
        file: StaticString = #file,
        line: UInt = #line
    ) -> SUT {
        
        let composer = Composer(storeURL: storeURL ?? testStoreURL())
        
        trackForMemoryLeaks(composer, file: file, line: line)
        
        return composer.compose()
    }
    
    private func setupEmptyStoreState() {
        
        clearArtifacts()
    }
    
    private func undoStoreSideEffects() {
        
        clearArtifacts()
    }
    
    private func clearArtifacts() {
        
        try? FileManager.default.removeItem(at: testStoreURL())
    }
    
    private func testStoreURL() -> URL {
        
        cachesDirectory()
            .appendingPathComponent("\(type(of: self)).store")
    }
    
    private func cachesDirectory() -> URL {
        
        return FileManager.default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first!
    }
}
