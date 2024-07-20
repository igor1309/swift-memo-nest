//
//  AnyLoader.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

/// A type-erased loader that can load data with any payload, success, and failure types.
public struct AnyLoader<Payload, Success, Failure: Error> {
    
    // The underlying load function.
    private let _load: Load
    
    /// Initialises a new instance of `AnyLoader`.
    /// - Parameter load: A closure that performs the load operation.
    public init(load: @escaping Load) {
        
        self._load = load
    }
    
    /// A typealias for the completion handler used in the load operation.
    public typealias LoadCompletion = (Result<Success,Failure>) -> Void
    
    /// A typealias for the load function.
    public typealias Load = (Payload, @escaping LoadCompletion) -> Void
}

/// A type-erased loader for void payloads.
public extension AnyLoader where Payload == Void {
    
    /// Initialises a new instance of `AnyLoader` for void payloads.
    /// - Parameter load: A closure that performs the load operation.
    init(load: @escaping (@escaping LoadCompletion) -> Void) {
        
        self._load = { _, completion in load(completion) }
    }
}

extension AnyLoader: Loader {
    
    /// Loads the data with the given payload and calls the completion handler with the result.
    /// - Parameters:
    ///   - payload: The payload to be loaded.
    ///   - completion: A closure to be called with the result of the load operation.
    public func load(
        _ payload: Payload,
        _ completion: @escaping LoadCompletion
    ) {
        _load(payload, completion)
    }
}
