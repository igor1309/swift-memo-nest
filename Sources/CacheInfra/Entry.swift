//
//  Entry.swift
//
//
//  Created by Igor Malyarov on 19.07.2024.
//

import Foundation

public struct Entry: Equatable {
    
    public let id: UUID
    public let creationDate: Date
    public let modificationDate: Date
    public let title: String
    public let url: URL?
    public let note: String
    public let tags: [String]
    
    public init(
        id: UUID,
        creationDate: Date,
        modificationDate: Date,
        title: String,
        url: URL?,
        note: String,
        tags: [String]
    ) {
        self.id = id
        self.creationDate = creationDate
        self.modificationDate = modificationDate
        self.title = title
        self.url = url
        self.note = note
        self.tags = tags
    }
}
