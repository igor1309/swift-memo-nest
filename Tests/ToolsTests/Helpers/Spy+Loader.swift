//
//  Spy+Loader.swift
//  
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Tools

extension Spy: Loader {
    
    func load(
        _ payload: Payload,
        _ completion: @escaping (Result<Success, Failure>) -> Void
    ) {
        process(payload, completion: completion)
    }
}
