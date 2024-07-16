//
//  Loader.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

public protocol Loader<Payload, Success, Failure> {
    
    associatedtype Payload
    associatedtype Success
    associatedtype Failure: Error
    
    func load(
        _: Payload,
        _: @escaping (Result<Success, Failure>) -> Void
    )
}

public extension Loader where Payload == Void {
    
    func load(
        _ completion: @escaping (Result<Success, Failure>) -> Void
    ) {
        load((), completion)
    }
}
