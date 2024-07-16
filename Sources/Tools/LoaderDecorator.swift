//
//  LoaderDecorator.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

public final class LoaderDecorator<Payload, Success, Failure: Error> {
    
    private let decoratee: Decoratee
    private let decorate: Decorate
    
    public init(
        decoratee: Decoratee,
        decorate: @escaping Decorate
    ) {
        self.decoratee = decoratee
        self.decorate = decorate
    }
    
    public typealias Decoratee = any Loader<Payload, Success, Failure>
    public typealias Decorate = (Result<Success, Failure>, @escaping () -> Void) -> Void
}

extension LoaderDecorator: Loader {
    
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
