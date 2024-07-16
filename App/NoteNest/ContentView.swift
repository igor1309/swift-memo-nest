//
//  ContentView.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import SwiftUI

struct ContentView: View {
    
    var body: some View {
        
        NavigationView {
            
            ListFlowView(model: .preview())
                .navigationTitle("Entries")
        }
    }
}

#Preview {
    ContentView()
}
