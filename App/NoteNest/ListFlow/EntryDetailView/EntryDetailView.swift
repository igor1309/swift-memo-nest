//
//  EntryDetailView.swift
//  NoteNest
//
//  Created by Igor Malyarov on 17.07.2024.
//

import SwiftUI

struct EntryDetailView: View {
    
    let entry: Entry
    
    var body: some View {
    
        VStack(spacing: 16) {
            
            Text(entry.text)
        }
    }
}
