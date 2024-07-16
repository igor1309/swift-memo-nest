//
//  ContentView.swift
//  NoteNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import SwiftUI

struct ContentView: View {
    
    private let composer: ContentViewComposer
    
    init() {
        
        let composer = EntryListModelComposer()
        self.composer = .init(makeEntryListModel: composer.compose)
    }
    
    var body: some View {
        
        NavigationView {
            
            ListFlowView(
                model: composer.composeViewModel(),
                factory: composer.composeFactory()
            )
            .navigationTitle("Entries")
        }
    }
}

#Preview {
    ContentView()
}
