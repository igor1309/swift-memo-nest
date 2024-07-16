//
//  FallbackCacheLoader.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

/// A loader that tries to load data from an in-memory store first, and if it fails, falls back to a persistent store.
/// On a successful load from the persistent store, it updates the in-memory store.
public final class FallbackCacheLoader<Payload, Success, Failure: Error> {
    
    private let loader: any Loader<Payload, Success, Failure>
    
    /// Initialises a new instance of `FallbackCacheLoader`.
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
        
        self.loader = StrategyLoader(
            primary: inMemoryLoader,
            secondary: decoratedPersistentLoader
        )
    }
}

extension FallbackCacheLoader: Loader {
    
    public func load(
        _ payload: Payload,
        _ completion: @escaping (LoadResult) -> Void
    ) {
        loader.load(payload, completion)
    }
}
