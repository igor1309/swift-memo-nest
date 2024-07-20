//
//  DispatchQueue+delay.swift
//  MemoNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Foundation

extension DispatchQueue {
    
    func delay(
        for timeInterval: DispatchTimeInterval,
        execute action: @escaping () -> Void
    ) {
        asyncAfter(
            deadline: .now() + timeInterval,
            execute: action
        )
    }
}
