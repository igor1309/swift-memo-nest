//
//  ReadCacheCoordinator+Loader.swift
//  
//
//  Created by Igor Malyarov on 21.07.2024.
//

import Foundation

extension ReadCacheCoordinator: Loader {
    
    /// Loads entries based on the given payload. It attempts to retrieve entries from the cache first,
    /// and falls back to the retrieval function if necessary.
    ///
    /// - Parameters:
    ///   - payload: The payload used for filtering and sorting entries.
    ///   - completion: A completion handler that receives the result of the load operation.
    public func load(
        _ payload: Payload,
        _ completion: @escaping LoadCompletion
    ) {
        Task { [weak self] in
            
            guard let self else { return }
            
            do {
                let entries = try await self.load(payload)
                completion(.success(entries))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    /// Typealias for the successful result containing an array of entries.
    public typealias Success = [Entry]
    
    /// Typealias for the failure result containing an error.
    public typealias Failure = Error
}
