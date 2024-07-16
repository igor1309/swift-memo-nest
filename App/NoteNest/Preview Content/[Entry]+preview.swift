//
//  [Entry]+preview.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import EntryListFeature
import Foundation

extension Array where Element == Entry {
    
    static func preview(count: Int = 10) -> Self {
        
        (0..<count).map { _ in
            
            return .init(
                id: UUID(),
                text: UUID().uuidString
            )
        }
    }
}
