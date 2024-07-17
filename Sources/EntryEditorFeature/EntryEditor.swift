//
//  EntryEditor.swift
//
//
//  Created by Igor Malyarov on 17.07.2024.
//

import SwiftUI

public struct EntryEditor: View {
    
    @FocusState private var isFocused
    @State private var newTag: String?
    
    @Binding private var entry: Entry
    
    public init(entry: Binding<Entry>) {
        
        self._entry = entry
    }
    
    public var body: some View {
        
        VStack(alignment: .leading, spacing: 24) {
            
            linkView(title: $entry.title, url: $entry.url)
            textEditor(text: $entry.note)
            tagsView()
        }
    }
}

private extension EntryEditor {
    
    func linkView(
        title: Binding<String>,
        url: Binding<URL?>
    ) -> some View {
        
        VStack(alignment: .leading, spacing: 6) {
            
            TextField("Title", text: title)
                .padding(.horizontal)
            
            TextField(
                "URL",
                value: url,
                format: URL.FormatStyle.urlStyle
            )
            .keyboardType(.URL)
            .textInputAutocapitalization(.never)
            .disableAutocorrection(true)
            .textContentType(.URL)
            .padding(.horizontal)
        }
    }
    
    func textEditor(
        text: Binding<String>
    ) -> some View {
        
        ZStack(alignment: .topLeading) {
            
            if text.wrappedValue.isEmpty {
                
                Text("Note")
                    .foregroundStyle(.tertiary)
                    .padding(.horizontal)
                    .padding(.vertical, 8)
            }
            
            TextEditor(text: text)
                .scrollContentBackground(.hidden)
                .padding(.horizontal, 12)
        }
    }
    
    func tagsView() -> some View {
        
        VStack(alignment: .leading, spacing: 8) {
            
            if let newTag {
                
                TextField(
                    "Enter tag",
                    text: .init(
                        get: { newTag },
                        set: { self.newTag = $0 }
                    )
                )
                .submitLabel(.join)
                .focused($isFocused)
                .onSubmit(of: .text) {
                    
                    if !newTag.isEmpty {
                        entry.tags.append(newTag)
                    }
                    
                    self.newTag = nil
                }
            }
            
            HStack {
                
                if !isFocused {
                    
                    Button {
                        newTag = ""
                        isFocused = true
                    } label: {
                        
                        Label("Show tag input field", systemImage: "plus.circle")
                            .imageScale(.large)
                    }
                    .labelStyle(.iconOnly)
                }
                
                Text(entry.tagsText)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.horizontal)
    }
}

private extension Entry {
    
    var tagsText: String {
        
        if tags.isEmpty {
            return "No Tags"
        } else {
            return tags.sorted().map { "#\($0)" }.joined(separator: ", ")
        }
    }
}

extension URL.FormatStyle {
    
    static let urlStyle: Self = .init(
        path: .omitWhen(.path, matches: ["/"]),
        query: .omitWhen(.query, matches: [""])
    )
}

// MARK: - Previews

private func entryEditorDemo(
    entry: Binding<Entry>
) -> some View {
    
    NavigationStack {
        
        EntryEditor(entry: entry)
            .navigationTitle("Editor")
            .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    
    entryEditorDemo(entry: .constant(.init()))
}

#Preview {
    
    entryEditorDemo(entry: .constant(.preview))
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
