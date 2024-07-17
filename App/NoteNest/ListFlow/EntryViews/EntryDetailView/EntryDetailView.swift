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
        
        VStack(alignment: .leading, spacing: 16) {
            
            linkView(link: entry.link)
            textView()
            tagsView(entry.tags)
        }
        .padding()
    }
}

private extension EntryDetailView {
    
    @ViewBuilder
    func linkView(
        link: Entry.Link
    ) -> some View {
        
        switch link {
        case .missing:
            EmptyView()
            
        case let .full(title, url):
            VStack(alignment: .leading, spacing: 6) {
                
                Link(destination: url) {
                    
                    Label(title, systemImage: "link")
                        .font(.headline)
                        .underline()
                }
                
                Text(url.absoluteString)
                    .italic()
                    .font(.caption)
            }
            
        case let .title(title):
            Text(title)
                .font(.headline)
            
        case let .url(url):
            Text(url.absoluteString)
                .italic()
                .font(.caption)
        }
    }
    
    @ViewBuilder
    func textView() -> some View {
        
        if !entry.text.isEmpty {
            Text(entry.text)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        } else {
            Spacer()
        }
    }
    
    func tagsView(
        _ tags: [String]
    ) -> some View {
        
        entry.tagsString.map(Text.init)
    }
}

private extension Entry {
    
    var link: Link {
        
        switch (title.isEmpty, url) {
        case (true, .none):
            return .missing
            
        case (false, .none):
            return .title(title)
            
        case let (true, .some(url)):
            return .url(url)
            
        case let (false, .some(url)):
            return .full(title: title, url: url)
        }
    }
    
    enum Link {
        
        case missing
        case full(title: String, url: URL)
        case title(String)
        case url(URL)
    }
}

// MARK: - Previews

private func entryDetailView(
    title: String,
    url: URL?,
    text: String = ""
) -> some View {
    
    EntryDetailView(entry: .init(title: title, url: url, text: text, tags: []))
        .border(.tertiary)
}

#Preview {
    
    VStack(alignment: .leading) {
        
        EntryDetailView(entry: .empty)
        entryDetailView(title: "", url: .init(string: "https://a.com"))
        entryDetailView(title: "Entry Title", url: .none)
        entryDetailView(title: "Entry Title", url: .init(string: "https://a.com"))
        entryDetailView(title: "", url: .none, text: "Lorem ipsum dolor sit amet")
    }
}

#Preview {
    
    EntryDetailView(entry: .preview)
}
