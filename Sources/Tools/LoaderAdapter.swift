//
//  LoaderAdapter.swift
//
//
//  Created by Igor Malyarov on 20.07.2024.
//

import Foundation

public final class LoaderAdapter<OriginalLoader: Loader, NewPayload, NewSuccess, NewFailure: Error> {
    
    public typealias Payload = NewPayload
    public typealias Success = NewSuccess
    public typealias Failure = NewFailure
    
    private let originalLoader: OriginalLoader
    private let mapPayload: (NewPayload) -> OriginalLoader.Payload
    private let mapSuccess: (OriginalLoader.Success) -> NewSuccess
    private let mapFailure: (OriginalLoader.Failure) -> NewFailure
    
    public init(
        originalLoader: OriginalLoader,
        mapPayload: @escaping (NewPayload) -> OriginalLoader.Payload,
        mapSuccess: @escaping (OriginalLoader.Success) -> NewSuccess,
        mapFailure: @escaping (OriginalLoader.Failure) -> NewFailure
    ) {
        self.originalLoader = originalLoader
        self.mapPayload = mapPayload
        self.mapSuccess = mapSuccess
        self.mapFailure = mapFailure
    }
}

extension LoaderAdapter: Loader {
    
    public func load(
        _ payload: NewPayload,
        _ completion: @escaping (Result<NewSuccess, NewFailure>) -> Void
    ) {
        let originalPayload = mapPayload(payload)
        
        originalLoader.load(originalPayload) { [weak self] originalResult in
            
            guard let self else { return }
            
            let newResult = originalResult
                .map(mapSuccess)
                .mapError(mapFailure)
            completion(newResult)
        }
    }
}

public extension LoaderAdapter
where NewPayload == OriginalLoader.Payload {
    
    convenience init(
        originalLoader: OriginalLoader,
        mapSuccess: @escaping (OriginalLoader.Success) -> NewSuccess,
        mapFailure: @escaping (OriginalLoader.Failure) -> NewFailure
    ) {
        self.init(
            originalLoader: originalLoader,
            mapPayload: { $0 },
            mapSuccess: mapSuccess,
            mapFailure: mapFailure
        )
    }
}

public extension LoaderAdapter
where NewPayload == OriginalLoader.Payload,
      NewFailure == OriginalLoader.Failure {
    
    convenience init(
        originalLoader: OriginalLoader,
        mapSuccess: @escaping (OriginalLoader.Success) -> NewSuccess
    )  {
        self.init(
            originalLoader: originalLoader,
            mapPayload: { $0 },
            mapSuccess: mapSuccess,
            mapFailure: { $0 }
        )
    }
}
