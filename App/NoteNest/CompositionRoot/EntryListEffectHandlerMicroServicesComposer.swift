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
        
        return .init(
            load: load,
            loadMoreAfter: loadMoreAfter
        )
    }
    
    typealias MicroServices = EntryListEffectHandlerMicroServices
}

private extension EntryListEffectHandlerMicroServicesComposer {
    
    func load(
        _ completion: @escaping MicroServices.LoadCompletion
    ) {
        random(completion)
    }
    
    func loadMoreAfter(
        id: Entry.ID,
        _ completion: @escaping MicroServices.LoadCompletion
    ) {
        random(completion)
    }
    
    private func random(
        _ completion: @escaping MicroServices.LoadCompletion
    ) {
        DispatchQueue.main.delay(for: .seconds(2)) {
            
            if Bool.random() {
                completion(.success(.stub(Int.random(in: 1...20))))
            } else {
                completion(.failure(.init()))
            }
        }
    }
}

private extension Array where Element == Entry {
    
    static let stub = preview
}
