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
        
        VStack(alignment: .leading, spacing: 24) {

            VStack(alignment: .leading, spacing: 6) {
                
                TextField("Title", text: $entry.title)
                    .padding(.horizontal)
                
                TextField(
                    "URL",
                    value: $entry.url,
                    format: URL.FormatStyle.urlStyle
                )
                .keyboardType(.URL)
                .textInputAutocapitalization(.never)
                .disableAutocorrection(true)
                .textContentType(.URL)
                .padding(.horizontal)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                
                Text("Note")
                    .foregroundStyle(.tertiary)
                    .font(.subheadline.weight(.medium))
                    .padding(.horizontal)
                
                TextEditor(text: $entry.note)
                    .padding(.horizontal, 12)
            }
            
            Text("Tags (TBD)")
                .padding(.horizontal)
        }
    }
}

extension Entry {
    
    static let empty: Self = .init(title: "", note: "", tags: [])
}

// MARK: - Previews

private func entryEditorDemo(
    entry: Entry? = nil
) -> some View {
    
    NavigationStack {
        
        EntryEditor(entry: entry)
            .navigationTitle("Editor")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    
    entryEditorDemo()
}

#Preview {
    
    entryEditorDemo(entry: .preview)
}

private extension Entry {
    
    static let preview: Self = .init(
        title: "",
        note: .loremIpsum,
        tags: []
    )
}

private extension String {
    
    static let loremIpsum = """
Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium.

Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet. Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue. Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus. Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum. Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus. Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante. Etiam sit amet orci eget eros faucibus tincidunt. Duis leo. Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna.
"""
}
