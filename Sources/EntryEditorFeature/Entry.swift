//
//  Entry.swift
//
//
//  Created by Igor Malyarov on 17.07.2024.
//

import Foundation

public struct Entry: Equatable {
    
    //public var link: Link?
    public var title: String
    public var url: URL?
    
    // TODO: switch to `AttributedString` for Markdown
    public var note: String
    public var tags: [String]
    
    public init(
        //        link: Link? = nil,
        title: String = "",
        url: URL? = nil,
        note: String = "",
        tags: [String] = []
    ) {
        //        self.link = link
        self.title = title
        self.url = url
        self.note = note
        self.tags = tags
    }
}

extension Entry {
    
    public struct Link: Equatable {
        
        var title: String
        var url: URL
    }
}
