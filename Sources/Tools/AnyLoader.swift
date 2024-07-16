//
//  AnyLoader.swift
//
//
//  Created by Igor Malyarov on 16.07.2024.
//

public struct AnyLoader<Payload, Success, Failure: Error> {
    
    private let _load: Load
    
    public init(load: @escaping Load) {
        
        self._load = load
    }
    
    public typealias LoadCompletion = (Result<Success,Failure>) -> Void
    public typealias Load = (Payload, @escaping LoadCompletion) -> Void
}

public extension AnyLoader where Payload == Void {
    
    init(load: @escaping (@escaping LoadCompletion) -> Void) {
        
        self._load = { _, completion in load(completion) }
    }
}

extension AnyLoader: Loader {
    
    public func load(
        _ payload: Payload,
        _ completion: @escaping LoadCompletion
    ) {
        _load(payload, completion)
    }
}
