//
//  EntryListEffectHandlerMicroServicesComposer.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import EntryListFeature
import Foundation

final class EntryListEffectHandlerMicroServicesComposer {}

extension EntryListEffectHandlerMicroServicesComposer {
    
    func compose() -> MicroServices {
        
        return .init(
            load: load,
            loadMoreAfter: loadMoreAfter
        )
    }
    
    typealias MicroServices = EntryListEffectHandlerMicroServices<Entry>
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
        DispatchQueue.main.delay(for: .seconds(1)) {
            
            if Bool.random() {
                completion(.success(.stub(count: Int.random(in: 1...20))))
            } else {
                completion(.failure(.init()))
            }
        }
    }
}

private extension Array where Element == Entry {
    
    static func stub(count: Int = 10) -> Self {
        
        (0..<count).map { _ in
            
            return .init(
                title: "Title \(String(UUID().uuidString.prefix(6)))",
                text: UUID().uuidString
            )
        }
    }
}
