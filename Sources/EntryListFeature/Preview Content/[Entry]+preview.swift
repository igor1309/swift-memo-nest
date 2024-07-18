//
//  [Entry]+preview.swift
//  
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Foundation

extension Array where Element == PreviewEntry {
    
    static func preview(count: Int = 10) -> Self {
        
        (0..<count).map { _ in
            
            return .init(note: UUID().uuidString)
        }
    }
}
