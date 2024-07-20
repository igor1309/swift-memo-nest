//
//  Entry.swift
//  MemoNest
//
//  Created by Igor Malyarov on 16.07.2024.
//

import Foundation

struct Entry: Equatable, Identifiable {
    
    let id: UUID
    let creationDate: Date
    let modificationDate: Date
    let title: String
    let url: URL?
    let note: String
    let tags: [String]
    
    init(
        id: UUID = .init(),
        creationDate: Date,
        modificationDate: Date,
        title: String,
        url: URL? = nil,
        note: String,
        tags: [String] = []
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
