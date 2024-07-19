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
    ///   - primaryLoader: The primary loader.
    ///   - secondaryLoader: The secondary loader.
    ///   - cache: A closure to update the store with the data loaded with secondary loader.
    public init(
        primaryLoader: any PrimaryLoader,
        secondaryLoader: any SecondaryLoader,
        cache: @escaping Cache
    ) {
        let decoratedPersistentLoader = LoaderDecorator(
            decoratee: secondaryLoader,
            decorate: { payload, result, completion in
                
                if case let .success(success) = result {
                    
                    cache(payload, success)
                }
                completion()
            }
        )
        
        self.loader = StrategyLoader(
            primary: primaryLoader,
            secondary: decoratedPersistentLoader
        )
    }
    
    public typealias PrimaryLoader = Loader<Payload, Success, Error>
    public typealias SecondaryLoader = Loader<Payload, Success, Failure>
    public typealias Cache = (Payload, Success) -> Void
}

extension FallbackCacheLoader: Loader {
    
    public func load(
        _ payload: Payload,
        _ completion: @escaping (LoadResult) -> Void
    ) {
        loader.load(payload, completion)
    }
}
