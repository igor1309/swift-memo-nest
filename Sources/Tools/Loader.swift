//
//  Loader.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

/// A protocol that defines a generic loader for loading data with a specific payload, success, and failure types.
public protocol Loader<Payload, Success, Failure> {
    
    /// The type of the payload to be loaded.
    associatedtype Payload
    
    /// The type of the success result.
    associatedtype Success
    
    /// The type of the failure result, which must conform to `Error`.
    associatedtype Failure: Error
    
    /// Loads the data with the given payload and calls the completion handler with the result.
    /// - Parameters:
    ///   - payload: The payload to be loaded.
    ///   - completion: A closure to be called with the result of the load operation.
    func load(
        _: Payload,
        _: @escaping (LoadResult) -> Void
    )
    
    /// A typealias for the result of the load operation.
    typealias LoadResult = Result<Success, Failure>
}

/// A default implementation of the `load` method for loaders with `Void` payloads.
public extension Loader where Payload == Void {
    
    /// Loads the data without a payload and calls the completion handler with the result.
    /// - Parameter completion: A closure to be called with the result of the load operation.
    func load(
        _ completion: @escaping (Result<Success, Failure>) -> Void
    ) {
        load((), completion)
    }
}
