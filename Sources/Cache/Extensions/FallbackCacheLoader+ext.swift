//
//  FallbackCacheLoader+ext.swift
//
//
//  Created by Igor Malyarov on 20.07.2024.
//

public extension FallbackCacheLoader {
    
    convenience init(
        primaryLoad: @escaping (Payload, @escaping (Result<Success, Error>) -> Void) -> Void,
        secondaryLoad: @escaping (Payload, @escaping (LoadResult) -> Void) -> Void,
        cache: @escaping (Payload, Success) -> Void
    ) {
        self.init(
            primaryLoader: AnyLoader(load: primaryLoad),
            secondaryLoader: AnyLoader(load: secondaryLoad),
            cache: cache
        )
    }
}
