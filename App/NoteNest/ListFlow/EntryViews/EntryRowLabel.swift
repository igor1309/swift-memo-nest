//
//  EntryRowLabel.swift
//  NoteNest
//
//  Created by Igor Malyarov on 17.07.2024.
//

import SwiftUI

struct EntryRowLabel: View {
    
    let entry: Entry
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            titleView()
            urlView()
            noteView()
            tagsView()
        }
    }
}

private extension EntryRowLabel {
    
    @ViewBuilder
    func titleView() -> some View {
        
        if !entry.title.isEmpty {
            
            Text(entry.title)
                .font(.headline)
        }
    }
    
    @ViewBuilder
    func urlView() -> some View {
        
        if let url = entry.url {
            
            (Text(Image(systemName: "link")) + Text(" \(url.absoluteString)"))
                .foregroundStyle(.tertiary)
                .font(.caption)
                .imageScale(.small)
        }
    }
    
    @ViewBuilder
    func noteView() -> some View {
        
        if !entry.text.isEmpty {
            
            Text(entry.text)
                .lineLimit(3)
                .font(.footnote)
                .foregroundStyle(.secondary)
        }
    }
    
    @ViewBuilder
    func tagsView() -> some View {
        
        if !entry.tags.isEmpty {
            
            entry.tagsString.map(Text.init)
                .font(.caption.italic())
        }
    }
}

#Preview {
    
    List {
        EntryRowLabel(entry: .empty)
        EntryRowLabel(entry: .preview)
    }
    .listStyle(.plain)
}
