//
//  LoaderDecorator.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

/// A decorator for any `Loader` that allows additional processing on the result.
public final class LoaderDecorator<Payload, Success, Failure: Error> {
    
    // The underlying loader that this decorator wraps.
    private let decoratee: any Decoratee
    
    // A closure that performs additional processing on the result.
    private let decorate: Decorate
    
    /// Initialises a new instance of the `LoaderDecorator`.
    /// - Parameters:
    ///   - decoratee: The loader to be decorated.
    ///   - decorate: A closure that performs additional processing on the result.
    public init(
        decoratee: any Decoratee,
        decorate: @escaping Decorate
    ) {
        self.decoratee = decoratee
        self.decorate = decorate
    }
    
    /// A typealias representing any `Loader` with specific payload, success, and failure types.
    public typealias Decoratee = Loader<Payload, Success, Failure>
    
    /// A typealias for a closure that processes the result and invokes a completion handler.
    public typealias Decorate = (Result<Success, Failure>, @escaping () -> Void) -> Void
}

extension LoaderDecorator: Loader {
    
    /// Loads the payload using the underlying loader and decorates the result.
    /// - Parameters:
    ///   - payload: The payload to be loaded.
    ///   - completion: A closure to be called with the decorated result.
    public func load(
        _ payload: Payload,
        _ completion: @escaping (Result<Success, Failure>) -> Void
    ) {
        decoratee.load(payload) { [weak self] result in
            
            guard let self else { return }
            
            decorate(result) { completion(result) }
        }
    }
}
