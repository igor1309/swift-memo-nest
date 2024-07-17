//
//  Entry+tagsString.swift
//  NoteNest
//
//  Created by Igor Malyarov on 17.07.2024.
//

extension Entry {
    
    var tagsString: String? {
        
        guard !tags.isEmpty else { return nil }
        
        return tags.sorted().map { "#\($0)" }.joined(separator: ", ")
    }
}
