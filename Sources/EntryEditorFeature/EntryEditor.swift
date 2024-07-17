//
//  EntryEditor.swift
//
//
//  Created by Igor Malyarov on 17.07.2024.
//

import SwiftUI

extension URL.FormatStyle {
    
    static let urlStyle: Self = .init(
        path: .omitWhen(.path, matches: ["/"]),
        query: .omitWhen(.query, matches: [""])
    )
}

public struct EntryEditor: View {
    
    @State private var entry: Entry
    
    public init(entry: Entry? = nil) {
        
        self.entry = entry ?? .empty
    }
    
    public var body: some View {
        
        List {
            
            Section("Link") {
                
                TextField("Title", text: $entry.title)
                
                TextField(
                    "URL",
                    value: $entry.url,
                    format: URL.FormatStyle.urlStyle
                )
                .keyboardType(.URL)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .textContentType(.URL)
            }
            .listSectionSeparator(.hidden)
            
            Section("Note") {
                
                TextEditor(text: $entry.note)
            }
            .listSectionSeparator(.hidden)
            
            Section("Tags") {
                
            }
        }
        .listStyle(.plain)
    }
}

extension Entry {
    
    static let empty: Self = .init(title: "", note: "", tags: [])
}

#Preview {
    
    NavigationStack {
        
        EntryEditor()
            .navigationTitle("Editor")
            .navigationBarTitleDisplayMode(.inline)
    }
}
