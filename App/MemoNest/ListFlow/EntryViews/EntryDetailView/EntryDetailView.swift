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
            datesView()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
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
        
        if !entry.note.isEmpty {
            
            Text(entry.note)
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
    
    func datesView(
    ) -> some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            Text("Created: \(entry.creationDate.formatted())")
            
            if entry.modificationDate.isSignificantlyDifferent(from: entry.creationDate) {
                
                Text("Modified: \(entry.modificationDate.formatted())")
            }
        }
        .foregroundStyle(.secondary)
        .font(.caption)
    }
}

private extension Date {
    
    func isSignificantlyDifferent(
        from other: Date,
        calendar: Calendar = .autoupdatingCurrent
    ) -> Bool {
        
        let diffComponents = Calendar.current.dateComponents([.minute], from: other, to: self)
        guard let minutes = diffComponents.minute
        else { return false }
        
        return minutes > 1
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
    note: String = ""
) -> some View {
    
    EntryDetailView(entry: .init(title, url, note: note))
        .border(.tertiary)
}

private extension Entry {
    
    init(
        _ title: String,
        _ url: URL?,
        note: String = ""
    ) {
        self.init(
            creationDate: .init().addingTimeInterval(-3_600),
            modificationDate: .init(),
            title: title,
            url: url,
            note: note
        )
    }
}

#Preview {
    
    VStack(alignment: .leading) {
        
        EntryDetailView(entry: .empty)
            .border(.tertiary)
        entryDetailView(title: "", url: .init(string: "https://a.com"))
        entryDetailView(title: "Entry Title", url: .none)
        entryDetailView(title: "Entry Title", url: .init(string: "https://a.com"))
        entryDetailView(title: "", url: .none, note: "Lorem ipsum dolor sit amet")
    }
}

#if DEBUG
#Preview {
    
    EntryDetailView(entry: .preview)
}
#endif
