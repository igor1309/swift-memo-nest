//
//  [Entry]+preview.swift
//  MemoNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import EntryListFeature
import Foundation

extension Array where Element == Entry {
    
    static func preview(count: Int = 10) -> Self {
        
        (0..<count).map { _ in
            
            return .init(
                creationDate: .init(),
                modificationDate: .init(),
                title: "Title \(String(UUID().uuidString.prefix(6)))",
                note: UUID().uuidString
            )
        }
    }
}
