//
//  StrategyLoader.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

/// A loader that tries to load data using a primary loader and falls back to a secondary loader if the primary fails.
public final class StrategyLoader<Payload, Success, Failure: Error> {
    
    // The primary loader.
    private let primary: any Primary
    
    // The secondary loader.
    private let secondary: any Secondary
    
    /// Initialises a new instance of `StrategyLoader`.
    /// - Parameters:
    ///   - primary: The primary loader.
    ///   - secondary: The secondary loader.
    public init(
        primary: any Primary,
        secondary: any Secondary
    ) {
        self.primary = primary
        self.secondary = secondary
    }
    
    /// A typealias for the primary loader.
    public typealias Primary = Loader<Payload, Success, Error>
    
    /// A typealias for the secondary loader.
    public typealias Secondary = Loader<Payload, Success, Failure>
}

extension StrategyLoader: Loader {
    
    /// Loads the data using the primary loader, and falls back to the secondary loader if the primary fails.
    /// - Parameters:
    ///   - payload: The payload to be loaded.
    ///   - completion: A closure to be called with the result of the load operation.
    public func load(
        _ payload: Payload,
        _ completion : @escaping (Result<Success, Failure>) -> Void
    ) {
        primary.load(payload) { [weak self] in
            
            guard let self else { return }
            
            switch $0 {
            case .failure:
                secondary.load(payload, completion)
                
            case let .success(success):
                completion(.success(success))
            }
        }
    }
}
