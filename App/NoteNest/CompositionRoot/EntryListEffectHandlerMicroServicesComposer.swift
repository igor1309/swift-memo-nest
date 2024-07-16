//
//  EntryListEffectHandlerMicroServicesComposer.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Foundation

final class EntryListEffectHandlerMicroServicesComposer {}

extension EntryListEffectHandlerMicroServicesComposer {
    
    func compose() -> MicroServices {
        
        return .init(load: load)
    }
    
    typealias MicroServices = EntryListEffectHandlerMicroServices
}

private extension EntryListEffectHandlerMicroServicesComposer {
    
    func load(
        _ completion: @escaping MicroServices.LoadCompletion
    ) {
        completion(.success(.stub(20)))
    }
}

private extension Array where Element == Entry {
    
    static let stub = preview
}
