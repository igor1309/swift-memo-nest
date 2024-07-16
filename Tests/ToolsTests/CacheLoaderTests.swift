//
//  CacheLoaderTests.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

/// A loader that tries to load data from an in-memory store first, and if it fails, falls back to a persistent store.
/// On a successful load from the persistent store, it updates the in-memory store.
public final class CacheLoader<Payload, Success, Failure: Error> {
    
    private let strategyLoader: StrategyLoader<Payload, Success, Failure>
    
    /// Initialises a new instance of `CacheLoader`.
    /// - Parameters:
    ///   - inMemoryLoader: The loader for the in-memory store.
    ///   - persistentLoader: The loader for the persistent store.
    ///   - updateInMemoryStore: A closure to update the in-memory store with the loaded data.
    public init(
        inMemoryLoader: any Loader<Payload, Success, Error>,
        persistentLoader: any Loader<Payload, Success, Failure>,
        updateInMemoryStore: @escaping (Payload, Success) -> Void
    ) {
        let decoratedPersistentLoader = LoaderDecorator(
            decoratee: persistentLoader,
            decorate: { payload, result, completion in
                
                if case let .success(success) = result {
                    
                    updateInMemoryStore(payload, success)
                }
                completion()
            }
        )
        
        self.strategyLoader = .init(
            primary: inMemoryLoader,
            secondary: decoratedPersistentLoader
        )
    }
}

extension CacheLoader: Loader {
    
    public func load(
        _ payload: Payload,
        _ completion: @escaping (LoadResult) -> Void
    ) {
        strategyLoader.load(payload, completion)
    }
}


import Tools
import XCTest

//final class CacheLoaderTests: XCTestCase {
//
//    // MARK: - Helpers
//
//    private typealias SUT = CacheLoader
//
//    private func makeSUT(
//        file: StaticString = #file,
//        line: UInt = #line
//    ) -> SUT {
//
//        let sut = SUT()
//
//        trackForMemoryLeaks(sut, file: file, line: line)
//
//        return sut
//    }
//}
